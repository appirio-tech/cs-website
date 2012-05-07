/**
 * xmlpure.js
 * 
 * Building upon and improving the CodeMirror 2 XML parser
 * @author: Dror BG (deebug.dev@gmail.com)
 * @date: August, 2011
 */
CodeMirror.defineMode("xmlpure",function(a,b){function p(a,b,c){return b.tokenize=c,c(a,b)}function q(a,b,c){return function(d,e){while(!d.eol()){if(d.match(b)){s(e),e.tokenize=c;break}d.next()}return a}}function r(a,b){var c=n.hasOwnProperty(b)||a.context&&a.context.doIndent,d={tagName:b,prev:a.context,indent:a.context?a.context.indent+o:0,lineNumber:a.lineNumber,indented:a.indented,noIndent:c};a.context=d}function s(a){if(a.context){var b=a.context;return a.context=b.prev,b}return null}function t(a){return a.sol()||a.string.charAt(a.start-1)==" "||a.string.charAt(a.start-1)=="\t"}function u(a,b){return a.eat("<")?a.eat("?")?(r(b,j),b.tokenize=B,d):a.match("!--")?(r(b,l),p(a,b,q(e,"-->",u))):a.eatSpace()||a.eol()?(a.skipToEnd(),c):(b.tokenize=v,f):(a.skipToEnd(),c)}function v(a,b){var d=a.pos;if(a.match(/^[a-zA-Z_:][-a-zA-Z0-9_:.]*/)){var e=a.string.substring(d,a.pos);return r(b,e),b.tokenize=w,f}if(a.match(/^\/[a-zA-Z_:][-a-zA-Z0-9_:.]*( )*>/)){var g=a.string.substring(d+1,a.pos-1).trim(),h=s(b);return b.tokenize=b.context==null?u:z,h==null||g!=h.tagName?c:f}return b.tokenize=b.context==null?u:z,a.eatWhile(/[^>]/),a.eat(">"),c}function w(a,b){return a.match(/^\/>/)?(s(b),b.tokenize=b.context==null?u:z,f):a.eat(/^>/)?(b.tokenize=z,f):t(a)&&a.match(/^[a-zA-Z_:][-a-zA-Z0-9_:.]*( )*=/)?(b.tokenize=x,g):(b.tokenize=b.context==null?u:u,a.eatWhile(/[^>]/),a.eat(">"),c)}function x(a,b){var d=a.next();return d!='"'&&d!="'"?(a.skipToEnd(),b.tokenize=w,c):(b.tokParams.quote=d,b.tokenize=y,h)}function y(a,b){var d="";while(!a.eol()){d=a.next();if(d==b.tokParams.quote)return b.tokenize=w,h;if(d=="<")return a.skipToEnd(),b.tokenize=w,c;if(d=="&"){d=a.next();if(d==";")return a.skipToEnd(),b.tokenize=w,c;while(!a.eol()&&d!=";"){if(d=="<")return a.skipToEnd(),b.tokenize=w,c;d=a.next()}if(a.eol()&&d!=";")return a.skipToEnd(),b.tokenize=w,c}}return h}function z(a,b){return a.eat("<")?a.match("?")?(r(b,j),b.tokenize=B,d):a.match("!--")?(r(b,l),p(a,b,q(e,"-->",b.context==null?u:z))):a.match("![CDATA[")?(r(b,k),p(a,b,q(i,"]]>",b.context==null?u:z))):a.eatSpace()||a.eol()?(a.skipToEnd(),c):(b.tokenize=v,f):(r(b,m),b.tokenize=A,null)}function A(a,b){return a.eatWhile(/[^<]/),a.eol()||(s(b),b.tokenize=z),i}function B(a,b){return a.match("xml",!0,!0)?b.lineNumber>1||a.pos>5?(b.tokenize=u,a.skipToEnd(),c):(b.tokenize=D,d):t(a)||a.match("?>")?(b.tokenize=u,a.skipToEnd(),c):(b.tokenize=C,d)}function C(a,b){return a.eatWhile(/[^?]/),a.eat("?")&&a.eat(">")&&(s(b),b.tokenize=b.context==null?u:z),d}function D(a,b){return b.tokenize=E,t(a)&&a.match(/^version( )*=( )*"([a-zA-Z0-9_.:]|\-)+"/)?d:(a.skipToEnd(),c)}function E(a,b){return b.tokenize=F,t(a)&&a.match(/^encoding( )*=( )*"[A-Za-z]([A-Za-z0-9._]|\-)*"/)?d:null}function F(a,b){return b.tokenize=G,t(a)&&a.match(/^standalone( )*=( )*"(yes|no)"/)?d:null}function G(a,b){return b.tokenize=u,a.match("?>")&&a.eol()?(s(b),d):(a.skipToEnd(),c)}var c="error",d="comment",e="comment",f="tag",g="attribute",h="string",i="atom",j="!instruction",k="!cdata",l="!comment",m="!text",n={"!cdata":!0,"!comment":!0,"!text":!0,"!instruction":!0},o=a.indentUnit;return{electricChars:"/[",startState:function(){return{tokenize:u,tokParams:{},lineNumber:0,lineError:!1,context:null,indented:0}},token:function(a,b){a.sol()&&(b.lineNumber++,b.lineError=!1,b.indented=a.indentation());if(a.eatSpace())return null;var c=b.tokenize(a,b);return b.lineError=b.lineError||c=="error",c},blankLine:function(a){a.lineNumber++,a.lineError=!1},indent:function(a,b){if(a.context){if(a.context.noIndent==1)return;return b.match(/^<\/.*/)?a.context.indent:b.match(/^<!\[CDATA\[/)?0:a.context.indent+o}return 0},compareStates:function(a,b){if(a.indented!=b.indented)return!1;for(var c=a.context,d=b.context;;c=c.prev,d=d.prev){if(!c||!d)return c==d;if(c.tagName!=d.tagName)return!1}}}}),CodeMirror.defineMIME("application/xml","purexml"),CodeMirror.defineMIME("text/xml","purexml")