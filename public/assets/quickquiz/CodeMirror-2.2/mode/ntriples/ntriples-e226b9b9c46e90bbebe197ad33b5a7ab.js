/**********************************************************
* This script provides syntax highlighting support for 
* the Ntriples format.
* Ntriples format specification: 
*     http://www.w3.org/TR/rdf-testcases/#ntriples
***********************************************************/
/* 
    The following expression defines the defined ASF grammar transitions.

    pre_subject ->
        {
        ( writing_subject_uri | writing_bnode_uri )
            -> pre_predicate 
                -> writing_predicate_uri 
                    -> pre_object 
                        -> writing_object_uri | writing_object_bnode | 
                          ( 
                            writing_object_literal 
                                -> writing_literal_lang | writing_literal_type
                          )
                            -> post_object
                                -> BEGIN
         } otherwise {
             -> ERROR
         }
*/
CodeMirror.defineMode("ntriples",function(){function a(a,b){var c=a.location,d;c==Location.PRE_SUBJECT&&b=="<"?d=Location.WRITING_SUB_URI:c==Location.PRE_SUBJECT&&b=="_"?d=Location.WRITING_BNODE_URI:c==Location.PRE_PRED&&b=="<"?d=Location.WRITING_PRED_URI:c==Location.PRE_OBJ&&b=="<"?d=Location.WRITING_OBJ_URI:c==Location.PRE_OBJ&&b=="_"?d=Location.WRITING_OBJ_BNODE:c==Location.PRE_OBJ&&b=='"'?d=Location.WRITING_OBJ_LITERAL:c==Location.WRITING_SUB_URI&&b==">"?d=Location.PRE_PRED:c==Location.WRITING_BNODE_URI&&b==" "?d=Location.PRE_PRED:c==Location.WRITING_PRED_URI&&b==">"?d=Location.PRE_OBJ:c==Location.WRITING_OBJ_URI&&b==">"?d=Location.POST_OBJ:c==Location.WRITING_OBJ_BNODE&&b==" "?d=Location.POST_OBJ:c==Location.WRITING_OBJ_LITERAL&&b=='"'?d=Location.POST_OBJ:c==Location.WRITING_LIT_LANG&&b==" "?d=Location.POST_OBJ:c==Location.WRITING_LIT_TYPE&&b==">"?d=Location.POST_OBJ:c==Location.WRITING_OBJ_LITERAL&&b=="@"?d=Location.WRITING_LIT_LANG:c==Location.WRITING_OBJ_LITERAL&&b=="^"?d=Location.WRITING_LIT_TYPE:b!=" "||c!=Location.PRE_SUBJECT&&c!=Location.PRE_PRED&&c!=Location.PRE_OBJ&&c!=Location.POST_OBJ?c==Location.POST_OBJ&&b=="."?d=Location.PRE_SUBJECT:d=Location.ERROR:d=c,a.location=d}return Location={PRE_SUBJECT:0,WRITING_SUB_URI:1,WRITING_BNODE_URI:2,PRE_PRED:3,WRITING_PRED_URI:4,PRE_OBJ:5,WRITING_OBJ_URI:6,WRITING_OBJ_BNODE:7,WRITING_OBJ_LITERAL:8,WRITING_LIT_LANG:9,WRITING_LIT_TYPE:10,POST_OBJ:11,ERROR:12},untilSpace=function(a){return a!=" "},untilEndURI=function(a){return a!=">"},{startState:function(){return{location:Location.PRE_SUBJECT,uris:[],anchors:[],bnodes:[],langs:[],types:[]}},token:function(b,c){var d=b.next();if(d=="<"){a(c,d);var e="";return b.eatWhile(function(a){return a!="#"&&a!=">"?(e+=a,!0):!1}),c.uris.push(e),b.match("#",!1)?"variable":(b.next(),a(c,">"),"variable")}if(d=="#"){var f="";return b.eatWhile(function(a){return a!=">"&&a!=" "?(f+=a,!0):!1}),c.anchors.push(f),"variable-2"}if(d==">")return a(c,">"),"variable";if(d=="_"){a(c,d);var g="";return b.eatWhile(function(a){return a!=" "?(g+=a,!0):!1}),c.bnodes.push(g),b.next(),a(c," "),"builtin"}if(d=='"')return a(c,d),b.eatWhile(function(a){return a!='"'}),b.next(),b.peek()!="@"&&b.peek()!="^"&&a(c,'"'),"string";if(d=="@"){a(c,"@");var h="";return b.eatWhile(function(a){return a!=" "?(h+=a,!0):!1}),c.langs.push(h),b.next(),a(c," "),"string-2"}if(d=="^"){b.next(),a(c,"^");var i="";return b.eatWhile(function(a){return a!=">"?(i+=a,!0):!1}),c.types.push(i),b.next(),a(c,">"),"variable"}d==" "&&a(c,d),d=="."&&a(c,d)}}}),CodeMirror.defineMIME("text/n-triples","ntriples")