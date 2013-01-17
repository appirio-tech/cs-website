/*
 Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config )
{
    /* Toolbars */
    config.toolbar = 'Easy';

    config.toolbar_Easy =
        [
            ['Bold','Italic','Strike'],
            ['BulletedList','NumberedList','Blockquote'],
            ['JustifyLeft','JustifyCenter','JustifyRight'],
            ['Link','Unlink'],
            ['Subscript', 'Superscript'],
            ['Image', 'Attachment', 'Flash', 'Embed'],
            ['YahooMaps', 'Dictionary'],
            '/',
            ['Format'],
            ['Underline', 'JustifyBlock', 'TextColor'],
            ['PasteText','PasteFromWord','RemoveFormat'],
            ['SpecialChar'],
            ['Outdent','Indent'],
            ['Undo','Redo'],
            ['Source']
        ];
};