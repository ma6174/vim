"#######################################################################
" Copyright (C) 2007 Adrien Friggeri.
"
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2, or (at your option)
" any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software Foundation,
" Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  
" 
" Maintainer:	Adrien Friggeri <adrien@friggeri.net>
"               Pigeond <http://pigeond.net/blog/>
"               Justin Sattery <justin.slattery@fzysqr.com>
"               Lenin Lee <lenin.lee@gmail.com>
"               Conner McDaniel <connermcd@gmail.com>
"
"     Forked:   Preston M.[BOYPT] <pentie@gmail.com>
"
" URL:		http://www.friggeri.net/projets/vimblog/
"           http://pigeond.net/blog/2009/05/07/vimpress-again/
"           http://pigeond.net/git/?p=vimpress.git
"           http://apt-blog.net
"           http://fzysqr.com/
"
" VimRepress 
"    - A mod of a mod of a mod of Vimpress.   
"    - A vim plugin fot writting your wordpress blog.
"
" Version:	2.1.5
"
" Configure: Add blog configure into your .vimrc (password optional)
"
" let VIMPRESS=[{'username':'user',
"               \'password':'pass',
"               \'blog_url':'http://your-first-blog.com/'
"               \},
"               \{'username':'user',
"               \'blog_url':'http://your-second-blog.com/'
"               \}]
"
"#######################################################################

if !has("python")
    finish
endif

function! CompSave(ArgLead, CmdLine, CursorPos)
  return "publish\ndraft\n"
endfunction

function! CompPrev(ArgLead, CmdLine, CursorPos)
  return "local\npublish\ndraft\n"
endfunction

function! CompEditType(ArgLead, CmdLine, CursorPos)
  return "post\npage\n"
endfunction

fun! Completable(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    " find matching items
    let res = []
    for m in split(s:completable,"|")
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfun

command! -nargs=* -complete=custom,CompEditType BlogList exec('py blog_list(<f-args>)')
command! -nargs=? -complete=custom,CompEditType BlogNew exec('py blog_new(<f-args>)')
command! -nargs=? -complete=custom,CompSave BlogSave exec('py blog_save(<f-args>)')
command! -nargs=? -complete=custom,CompPrev BlogPreview exec('py blog_preview(<f-args>)')
command! -nargs=1 -complete=file BlogUpload exec('py blog_upload_media(<f-args>)')
command! -nargs=1 BlogOpen exec('py blog_guess_open(<f-args>)')
command! -nargs=? BlogSwitch exec('py blog_config_switch(<f-args>)')
command! -nargs=? BlogCode exec('py blog_append_code(<f-args>)')

python << EOF
# -*- coding: utf-8 -*-
import urllib, urllib2, vim, xml.dom.minidom, xmlrpclib, sys, string, re, os, mimetypes, webbrowser, tempfile, time
try:
    import markdown
except ImportError:
    class markdown_stub(object):
        def markdown(self, n):
            raise VimPressException("The package python-markdown is required and is either not present or not properly installed.")
    markdown = markdown_stub()

image_template = '<a href="%(url)s"><img title="%(file)s" alt="%(file)s" src="%(url)s" class="aligncenter" /></a>'
blog_username = None
blog_password = None
blog_url = None
blog_conf_index = 0
vimpress_view = 'edit'
vimpress_temp_dir = ''

mw_api = None
wp_api = None
marker = ("=========== Meta ============", "=============================", "========== Content ==========")
list_view_key_map = dict(enter = "<enter>", delete = "<delete>")

tag_string = "<!-- #VIMPRESS_TAG# %(url)s %(file)s -->"
tag_re = re.compile(tag_string % dict(url = '(?P<mkd_url>\S+)', file = '(?P<mkd_name>\S+)'))

default_meta = dict(strid = "", title = "", slug = "", 
        cats = "", tags = "", editformat = "Markdown", edittype = "post", textattach = '')

class VimPressException(Exception):
    pass

class VimPressFailedGetMkd(VimPressException):
    pass

def markdown2html(rawtext):
    # see http://www.freewisdom.org/projects/python-markdown/Available_Extensions
    exts = ['meta', 'toc(marker=$TOC$)', 'def_list', 'abbr', 'footnotes', 'tables', 'codehilite', 'fenced_code']
    html = markdown.markdown(rawtext.decode('utf-8'), exts).encode('utf-8')
    return html

def blog_meta_parse():
    """
    Parses the meta data region of a blog editing buffer.
    @returns a dictionary of the meta data
    """
    meta = dict()
    start = 0
    while not vim.current.buffer[start][1:].startswith(marker[0]):
        start +=1

    end = start + 1
    while not vim.current.buffer[end][1:].startswith(marker[2]):
        if not vim.current.buffer[end].startswith('"===='):
            line = vim.current.buffer[end][1:].strip().split(":")
            k, v = line[0].strip().lower(), ':'.join(line[1:])
            meta[k.strip().lower()] = v.strip()
        end += 1

    meta["post_begin"] = end + 1
    return meta

def blog_meta_area_update(**kw):
    """
    Updates the meta data region of a blog editing buffer.
    @params **kwargs - keyworded arguments
    """
    start = 0
    while not vim.current.buffer[start][1:].startswith(marker[0]):
        start +=1

    end = start + 1
    while not vim.current.buffer[end][1:].startswith(marker[2]):
        if not vim.current.buffer[end].startswith('"===='):
            line = vim.current.buffer[end][1:].strip().split(":")
            k, v = line[0].strip().lower(), ':'.join(line[1:])
            if k in kw:
                new_line = "\"%s: %s" % (line[0], kw[k])
                vim.current.buffer[end] = new_line
        end += 1

def blog_fill_meta_area(meta):
    """
    Creates the meta data region for a blog editing buffer using a dictionary of meta data. Empty keywords
    are replaced by default values from the default_meta variable.
    @params meta - a dictionary of meta data
    """
    for k in default_meta.keys():
        if k not in meta:
            meta[k] = default_meta[k]

    meta.update(dict(bg = marker[0], mid = marker[1], ed = marker[2]))
    template = dict( \
        post = \
""""%(bg)s
"StrID : %(strid)s
"Title : %(title)s
"Slug  : %(slug)s
"Cats  : %(cats)s
"Tags  : %(tags)s
"%(mid)s
"EditType   : %(edittype)s
"EditFormat : %(editformat)s
"TextAttach : %(textattach)s
"%(ed)s""", 
        page = \
""""%(bg)s
"StrID : %(strid)s
"Title : %(title)s
"Slug  : %(slug)s
"%(mid)s
"EditType   : %(edittype)s
"EditFormat : %(editformat)s
"TextAttach : %(textattach)s
"%(ed)s""") 

    if meta["edittype"] not in ("post", "page"):
        raise VimPressException("Invalid option: %(edittype)s " % meta)
    meta_text = template[meta["edittype"].lower()] % meta
    meta = meta_text.split('\n')
    vim.current.buffer[0] = meta[0]
    vim.current.buffer.append(meta[1:])

def blog_get_mkd_attachment(post):
    """
    Attempts to find a vimpress tag containing a URL for a markdown attachment and parses it.
    @params post - the content of a post
    @returns a dictionary with the attachment's content and URL
    """

    attach = dict()
    try:
        lead = post.rindex("<!-- ")
        data = re.search(tag_re, post[lead:])
        if data is None:
            raise ValueError()
        attach.update(data.groupdict())
        attach["mkd_rawtext"] = urllib2.urlopen(attach["mkd_url"]).read()
    except ValueError, e:
        return dict()
    except IOError:
        raise VimPressFailedGetMkd("The attachment URL was found but was unable to be read.")

    return attach

def blog_upload_markdown_attachment(post_id, attach_name, mkd_rawtext):
    """
    Uploads the markdown attachment.
    @params post_id     - the id of the post or page
            attach_name - the name of the attachment
            mkd_rawtext - the Markdown content
    """
    bits = xmlrpclib.Binary(mkd_rawtext)

    # New Post, new file
    if post_id == '' or attach_name == '':
        attach_name = "vimpress_%s_mkd.txt" % hex(int(time.time()))[2:]
        overwrite = False
    else:
        overwrite = True

    sys.stdout.write("Markdown file uploading ... ")
    result = mw_api.newMediaObject(1, blog_username, blog_password, 
                dict(name = attach_name, 
                    type = "text/plain", bits = bits, 
                    overwrite = overwrite))
    sys.stdout.write("%s\n" % result["file"])
    return result

def __exception_check(func):
    def __check(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except VimPressException, e:
            sys.stderr.write(str(e))
        except xmlrpclib.Fault, e:
            sys.stderr.write("xmlrpc error: %s" % e.faultString.encode("utf-8"))
        except xmlrpclib.ProtocolError, e:
            sys.stderr.write("xmlrpc error: %s %s" % (e.url, e.errmsg))
        except IOError, e:
            sys.stderr.write("network error: %s" % e)

    return __check

def __vim_encoding_check(func):
    def __check(*args, **kw):
        orig_enc = vim.eval("&encoding") 
        if orig_enc != "utf-8":
            modified = vim.eval("&modified")
            buf_list = '\n'.join(vim.current.buffer).decode(orig_enc).encode('utf-8').split('\n')
            del vim.current.buffer[:]
            vim.command("setl encoding=utf-8")
            vim.current.buffer[0] = buf_list[0]
            if len(buf_list) > 1:
                vim.current.buffer.append(buf_list[1:])
            if modified == '0':
                vim.command('setl nomodified')
        return func(*args, **kw)
    return __check

def __xmlrpc_api_check(func):
    def __check(*args, **kw):
        if wp_api is None or mw_api is None:
            blog_update_config()
        return func(*args, **kw)
    return __check

@__exception_check
@__vim_encoding_check
@__xmlrpc_api_check
def blog_save(pub = "draft"):
    """
    Saves the current editing buffer.
    @params pub - either "draft" or "publish"
    """
    if vimpress_view != 'edit':
        raise VimPressException("Command not available at list view.")
    if pub not in ("publish", "draft"):
        raise VimPressException(":BlogSave draft|publish")

    is_publish = (pub == "publish")

    meta = blog_meta_parse()
    rawtext = '\n'.join(vim.current.buffer[meta["post_begin"]:])

    #Translate markdown and upload as attachment 
    if meta["editformat"].strip().lower() == "markdown":
        attach = blog_upload_markdown_attachment(
                meta["strid"], meta["textattach"], rawtext)
        blog_meta_area_update(textattach = attach["file"])
        text = markdown2html(rawtext)

        # Add tag string at the last of the post.
        text += tag_string % attach
    else:
        text = rawtext

    edit_type = meta["edittype"]
    strid = meta["strid"] 

    if edit_type.lower() not in ("post", "page"):
        raise VimPressException(
                "Fail to work with edit type %s " % edit_type)

    post_struct = dict(title = meta["title"], wp_slug = meta["slug"], 
                    description = text)
    if edit_type == "post":
        post_struct.update(categories = meta["cats"].split(','), 
                        mt_keywords = meta["tags"].split(','))

    # New posts
    if strid == '':
        if edit_type == "post":
            strid = mw_api.newPost('', blog_username, blog_password, 
                    post_struct, is_publish)
        else:
            strid = wp_api.newPage('', blog_username, blog_password, 
                    post_struct, is_publish)

        meta["strid"] = strid

        # update meat area if slug or categories is empty
        if edit_type == "post":
            if meta["slug"] == '' or meta["cats"] == '':
                data = mw_api.getPost(strid, blog_username, blog_password)
                cats = ",".join(data["categories"]).encode("utf-8")
                slug = data["wp_slug"].encode("utf-8")
                meta["cats"] = cats
                meta["slug"] = slug
        else: 
            if meta["slug"] == '':
                data = wp_api.getPage('', strid, blog_username, blog_password)
                slug = data["wp_slug"].encode("utf-8")
                meta["slug"] = slug

        blog_meta_area_update(**meta)

        notify = "%s %s.   ID=%s" % \
                (edit_type.capitalize(), 
                        "Published" if is_publish else "Saved as draft", strid)

    # Old posts
    else:
        if edit_type == "post":
            mw_api.editPost(strid, blog_username, blog_password, 
                    post_struct, is_publish)
        elif edit_type == "page":
            wp_api.editPage('', strid, blog_username, blog_password, 
                    post_struct, is_publish)

        notify = "%s edited and %s.   ID=%s" % \
                (edit_type.capitalize(), "published" if is_publish else "saved as a draft", strid)

    sys.stdout.write(notify)
    vim.command('setl nomodified')

    return meta

@__exception_check
@__vim_encoding_check
@__xmlrpc_api_check
def blog_new(edit_type = "post"):
    """
    Creates a new editing buffer of specified type.
    @params edit_type - either "post" or "page"
    """
    global vimpress_view

    if edit_type.lower() not in ("post", "page"):
        raise VimPressException("Invalid option: %s " % edit_type)

    if vimpress_view.startswith("list"):
        currentContent = ['']
        for v in list_view_key_map.values():
            if vim.eval("mapcheck('%s')" % v):
                vim.command('unmap <buffer> %s' % v)
    else:
        currentContent = vim.current.buffer[:]

    blog_wise_open_view()
    vimpress_view = 'edit'
    meta_dict = dict(edittype = edit_type)
    blog_fill_meta_area(meta_dict)
    vim.current.buffer.append(currentContent)
    vim.current.window.cursor = (1, 0)
    vim.command('setl nomodified')
    vim.command('setl textwidth=0')

@__xmlrpc_api_check
def blog_edit(edit_type, post_id):
    """
    Opens a new editing buffer with blog content of specified type and id.
    @params edit_type - either "post" or "page"
            post_id   - the id of the post or page
    """
    global vimpress_view
    vimpress_view = 'edit'

    blog_wise_open_view()

    if edit_type.lower() not in ("post", "page"):
        raise VimPressException("Invalid option: %s " % edit_type)

    if edit_type.lower() == "post":
        data = mw_api.getPost(post_id, blog_username, blog_password)
    else: 
        data = wp_api.getPage('', post_id, blog_username, blog_password)

    meta_dict = dict(\
            strid = str(post_id), 
            title = data["title"].encode("utf-8"), 
            slug = data["wp_slug"].encode("utf-8"))
    content = data["description"]
    post_more = data.get("mt_text_more", '')
    page_more = data.get("text_more", '')

    if len(post_more) > 0:
        content += '<!--more-->' + post_more
    elif len(page_more) > 0:
        content += '<!--more-->' + page_more

    content = content.encode("utf-8")

    if edit_type.lower() == "post":
        meta_dict["cats"] = ",".join(data["categories"]).encode("utf-8") 
        meta_dict["tags"] = data["mt_keywords"].encode("utf-8")

    meta_dict['editformat'] = "HTML"
    meta_dict['edittype'] = edit_type

    try:
        attach = blog_get_mkd_attachment(content)
        if "mkd_rawtext" in attach:
            meta_dict['editformat'] = "Markdown"
            meta_dict['textattach'] = attach["mkd_name"]
            content = attach["mkd_rawtext"]
    except VimPressFailedGetMkd:
        pass

    blog_fill_meta_area(meta_dict)
    meta = blog_meta_parse()
    vim.current.buffer.append(content.split('\n'))
    vim.current.window.cursor = (meta["post_begin"], 0)
    vim.command('setl nomodified')
    vim.command('setl textwidth=0')

    for v in list_view_key_map.values():
        if vim.eval("mapcheck('%s')" % v):
            vim.command('unmap <buffer> %s' % v)

@__xmlrpc_api_check
def blog_delete(edit_type, post_id):
    """
    Deletes a page or post of specified id.
    @params edit_type - either "page" or "post"
            post_id   - the id of the post or page
    """
    global vimpress_view
    if edit_type.lower() not in ("post", "page"):
        raise VimPressException("Invalid option: %s " % edit_type)

    if edit_type.lower() == "post":
        deleted = mw_api.deletePost('0123456789ABCDEF', post_id, blog_username, blog_password, True)
    else:
        deleted = wp_api.deletePage('', blog_username, blog_password, post_id)

    if deleted:
        sys.stdout.write("Deleted %s id %s. \n" % (edit_type, str(post_id)))
    else:
        sys.stdout.write("There was a problem deleting the %s.\n" % edit_type)

    if vimpress_view.startswith("list"):
        blog_list(edit_type)

@__exception_check
def blog_list_on_key_press(action):
    """
    Calls blog open on the current line of a listing buffer.
    """
    global vimpress_view
    if action.lower() not in ("open", "delete"):
        raise VimPressException("Invalid option: %s" % action)

    global vimpress_view
    row = vim.current.window.cursor[0]
    line = vim.current.buffer[row - 1]
    id = line.split()[0]
    title = line[len(id):].strip()

    try:
        int(id)
    except ValueError:
        raise VimPressException("Move cursor to a post/page line and press KEY.")

    if len(title) > 30:
        title = title[:30] + ' ...'

    if action.lower() == "delete":
        confirm = vim_input("Confirm Delete [%s]: %s? [yes/NO]" % (id,title))
        if confirm != 'yes':
            sys.stdout.write("Delete Aborted.\n")
            return

    vim.command("setl modifiable")
    del vim.current.buffer[:]
    vim.command("setl nomodified")

    if vimpress_view == "list_page":
        edit_type = "page"
    elif vimpress_view == "list_post":
        edit_type = "post"
    else:
        raise VimPressException("Command only available in list view.")

    if action == "open":
        blog_edit(edit_type, int(id))
    elif action == "delete":
        blog_delete(edit_type, int(id))

@__exception_check
@__vim_encoding_check
@__xmlrpc_api_check
def blog_list(edit_type = "post", count = "30"):
    """
    Creates a listing buffer of specified type.
    @params edit_type - either "post(s)" or "page(s)"
            count     - number to show (only for posts)
    """
    global vimpress_view
    vimpress_view = 'list'

    blog_wise_open_view()
    vim.current.buffer[0] = "\"====== List of %ss in %s =========" % (edit_type.capitalize(), blog_url)

    if edit_type.lower() not in ("post", "posts", "page", "pages"):
        raise VimPressException("Invalid option: %s " % edit_type)

    if edit_type.lower() in ("post", "posts"):
        vimpress_view = 'list_post'
        allposts = mw_api.getRecentPosts('',blog_username, blog_password, int(count))
        vim.current.buffer.append(\
            [(u"%(postid)s\t%(title)s" % p).encode('utf8') for p in allposts])
    else:
        vimpress_view = 'list_page'
        pages = wp_api.getPageList('', blog_username, blog_password)
        vim.current.buffer.append(\
            [(u"%(page_id)s\t%(page_title)s" % p).encode('utf8') for p in pages])

    vim.command("setl nomodified")
    vim.command("setl nomodifiable")
    vim.current.window.cursor = (2, 0)
    vim.command("map <silent> <buffer> %(enter)s :py blog_list_on_key_press('open')<cr>" % list_view_key_map)
    vim.command("map <silent> <buffer> %(delete)s :py blog_list_on_key_press('delete')<cr>" % list_view_key_map)
    sys.stdout.write("Press <Enter> to edit. <Delete> to move to trash.\n")

@__exception_check
@__vim_encoding_check
@__xmlrpc_api_check
def blog_upload_media(file_path):
    """
    Uploads a file to the blog.
    @params file_path - the file's path
    """
    if vimpress_view != 'edit':
        raise VimPressException("Command not available at list view.")
    if not os.path.exists(file_path):
        raise VimPressException("File does not exist: %s" % file_path)

    name = os.path.basename(file_path)
    filetype = mimetypes.guess_type(file_path)[0]
    with open(file_path) as f:
        bits = xmlrpclib.Binary(f.read())

    result = mw_api.newMediaObject('', blog_username, blog_password, 
            dict(name = name, type = filetype, bits = bits))

    ran = vim.current.range
    if filetype.startswith("image"):
        img = image_template % result
        ran.append(img)
    else:
        ran.append(result["url"])
    ran.append('')

@__exception_check
@__vim_encoding_check
def blog_append_code(code_type = ""):
    if vimpress_view != 'edit':
        raise VimPressException("Command not available at list view.")
    html = \
"""<pre %s>
</pre>"""
    if code_type != "":
        args = 'lang="%s" line="1"' % code_type
    else:
        args = 'lang="text"'

    row, col = vim.current.window.cursor 
    code_block = (html % args).split('\n')
    vim.current.range.append(code_block)
    vim.current.window.cursor = (row + len(code_block), 0)

@__exception_check
@__vim_encoding_check
def blog_preview(pub = "local"):
    """
    Opens a browser window displaying the content.
    @params pub - If "local", the content is shown in a browser locally.
                  If "draft", the content is saved as a draft and previewed remotely.
                  If "publish", the content is published and displayed remotely.
    """
    if vimpress_view != 'edit':
        raise VimPressException("Command not available at list view.")
    meta = blog_meta_parse()
    rawtext = '\n'.join(vim.current.buffer[meta["post_begin"]:])

    if pub == "local":
        if meta["editformat"].strip().lower() == "markdown":
            html = markdown2html(rawtext)
            html_preview(html, meta)
        else:
            html_preview(rawtext, meta)
    elif pub == "publish" or pub == "draft":
        meta = blog_save(pub)
        if meta["edittype"] == "page":
            prev_url = "%s?pageid=%s&preview=true" % (blog_url, meta["strid"])
        else:
            prev_url = "%s?p=%s&preview=true" % (blog_url, meta["strid"])
        webbrowser.open(prev_url)
        if pub == "draft":
            sys.stdout.write("\nYou have to login in the browser to preview the post when save as draft.")
    else:
        raise VimPressException("Invalid option: %s " % pub)
    vim.command('redraw!')


@__exception_check
def blog_guess_open(what):
    """
    Tries several methods to get the post id from different user inputs, such as args, url, postid etc.
    """ 
    post_id = ''
    blog_index = -1
    if type(what) is str:

        for i, p in enumerate(vim.eval("VIMPRESS")):
            if what.startswith(p["blog_url"]):
                blog_index = i

        # User input a url contained in the profiles
        if blog_index != -1:
            guess_id = re.search(r"\S+?p=(\d+)$", what)

            # permantlinks
            if guess_id is None:

                # try again for /archives/%post_id%
                guess_id = re.search(r"\S+/archives/(\d+)", what)

                # fail,  try get full link from headers
                if guess_id is None:
                    headers = urllib.urlopen(what).headers.headers
                    for link in headers:
                        if link.startswith("Link:"):
                            post_id = re.search(r"<\S+?p=(\d+)>", link).group(1)

                    # fail, just give up
                    if post_id == '':
                        raise VimPressException("Failed to get post/page id from '%s'." % what)
                else:
                    post_id = guess_id.group(1)

            # full link with ID (http://blog.url/?p=ID)
            else:
                post_id = guess_id.group(1)

        # Uesr input something not a usabe url, try numberic
        else:
            try:
                post_id = str(int(what))
            except ValueError:
                pass

    # detected something
    if post_id != '':
        if blog_index != -1 and blog_index != blog_conf_index:
            blog_config_switch(blog_index)
        blog_edit("post", post_id)
    else:
        raise VimPressException("Failed to get post/page id from '%s'." % what)


@__exception_check
def blog_update_config():
    """
    Updates the script's configuration variables.
    """
    global blog_username, blog_password, blog_url, mw_api, wp_api
    try:
        config = vim.eval("VIMPRESS")[blog_conf_index]
        blog_username = config['username']
        blog_url = config['blog_url']
        sys.stdout.write("Connecting to %s \n" % blog_url)
        blog_password = config.get('password', '')
        if blog_password == '':
           blog_password = vim_input("Enter password for %s" % blog_url, True)
        mw_api = xmlrpclib.ServerProxy("%s/xmlrpc.php" % blog_url).metaWeblog
        wp_api = xmlrpclib.ServerProxy("%s/xmlrpc.php" % blog_url).wp

        # Setting tags and categories for completefunc
        terms = []
        terms.extend([i["description"].encode("utf-8") 
            for i in mw_api.getCategories('', blog_username, blog_password)])
        # adding tags may make the menu too much items to choose.
        #terms.extend([i["name"].encode("utf-8") for i in wp_api.getTags('', blog_username, blog_password)])
        vim.command('let s:completable = "%s"' % '|'.join(terms))

    except vim.error:
        raise VimPressException("Could not find vimpress configuration. Please read ':help vimpress' for more information.")
    except KeyError, e:
        raise VimPressException("Configuration error: %s" % e)

@__vim_encoding_check
def vim_input(message = 'input', secret = False):
    vim.command('call inputsave()')
    vim.command("let user_input = %s('%s :')" % (("inputsecret" if secret else "input"), message))
    vim.command('call inputrestore()')
    return vim.eval('user_input')

@__exception_check
@__vim_encoding_check
def blog_config_switch(conf_index = -1):
    """
    Switches the blog to the next index of the configuration array.
    """
    global blog_conf_index
    try:
        conf_index = int(conf_index)
    except ValueError:
        raise VimPressException("Invalid Index: %s" % conf_index)

    conf = vim.eval("VIMPRESS")
    if conf_index == -1:
        blog_conf_index += 1
        if blog_conf_index >= len(conf):
            blog_conf_index = 0
    else:
        if conf_index >= len(conf):
            raise VimPressException("Invalid Index: %d" % conf_index)
        blog_conf_index = conf_index

    blog_update_config()
    if vimpress_view.startswith('list'):
        blog_list()
    sys.stdout.write("Vimpress switched to %s" % blog_url)

def html_preview(text_html, meta):
    """
    Opens a browser with a local preview of the content.
    @params text_html - the html content
            meta      - a dictionary of the meta data
    """
    global vimpress_temp_dir
    if vimpress_temp_dir == '':
        vimpress_temp_dir = tempfile.mkdtemp(suffix="vimpress")
    
    html = \
"""<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Vimpress Local Preview: %(title)s</title>
<style type="text/css"> ul, li { margin: 1em; } :link,:visited { text-decoration:none } h1,h2,h3,h4,h5,h6,pre,code { font-size:1em; } a img,:link img,:visited img { border:none } body { margin:0 auto; width:770px; font-family: Helvetica, Arial, Sans-serif; font-size:12px; color:#444; }
</style>
</meta>
</head>
<body> 
%(content)s 
</body>
</html>
""" % dict(content = text_html, title = meta["title"])
    with open(os.path.join(vimpress_temp_dir, "vimpress_temp.html"), 'w') as f:
        f.write(html)
    webbrowser.open("file://%s" % f.name)

def blog_wise_open_view():
    """
    Wisely decides whether to wipe out the content of current buffer or open a new splited window.
    """
    if vim.current.buffer.name is None and \
            (vim.eval('&modified') == '0' or \
                len(vim.current.buffer) == 1):
        vim.command('setl modifiable')
        del vim.current.buffer[:]
        vim.command('setl nomodified')
    else:
        vim.command(":new")
    vim.command('setl syntax=blogsyntax')
    vim.command('setl completefunc=Completable')
