CodeMirror.defineMode("rst",function(a,b){function c(a,b,c){a.fn=b,d(a,c)}function d(a,b){a.ctx=b||{}}function e(a,b){if(b&&typeof b!="string"){var d=b.current();b=d[d.length-1]}c(a,x,{back:b})}function f(a){if(a){var b=CodeMirror.listModes();for(var c in b)if(b[c]==a)return!0}return!1}function g(b){return f(b)?CodeMirror.getMode(a,b):null}function x(a,b){function l(a){return f||!b.ctx.back||a.test(b.ctx.back)}function m(b){return a.eol()||a.match(b,!1)}function n(b){return a.match(b)&&l(/\W/)&&m(/\W/)}var d,f,g;if(a.eat(/\\/))return d=a.next(),e(b,d),null;f=a.sol();if(f&&(d=a.eat(j))){for(g=0;a.eat(d);g++);if(g>=3&&a.match(/^\s*$/))return e(b,null),"header";a.backUp(g+1)}if(f&&a.match(q))return a.eol()||c(b,z),"meta";if(a.match(r)){if(!h)c(b,C);else{var k=h;c(b,C,{mode:k,local:k.startState()})}return"meta"}if(f&&a.match(w,!1)){if(!i)return c(b,C),"meta";var k=i;return c(b,C,{mode:k,local:k.startState()}),null}if(n(o))return e(b,a),"footnote";if(n(p))return e(b,a),"citation";d=a.next();if(l(s)){if(!(d!==":"&&d!=="|"||!a.eat(/\S/))){var t;return d===":"?t="builtin":t="atom",c(b,y,{ch:d,wide:!1,prev:null,token:t}),t}if(d==="*"||d==="`"){var u=d,v=!1;d=a.next(),d==u&&(v=!0,d=a.next());if(d&&!/\s/.test(d)){var t;return u==="*"?t=v?"strong":"em":t=v?"string":"string-2",c(b,y,{ch:u,wide:v,prev:null,token:t}),t}}}return e(b,d),null}function y(a,b){function g(a){return b.ctx.prev=a,f}var d=a.next(),f=b.ctx.token;if(d!=b.ctx.ch)return g(d);if(/\s/.test(b.ctx.prev))return g(d);if(b.ctx.wide){d=a.next();if(d!=b.ctx.ch)return g(d)}return!a.eol()&&!t.test(a.peek())?(b.ctx.wide&&a.backUp(1),g(d)):(c(b,x),e(b,d),f)}function z(a,b){var d=null;if(a.match(k))d="attribute";else if(a.match(l))d="link";else if(a.match(m))d="quote";else if(a.match(n))d="quote";else return a.eatSpace(),a.eol()?(e(b,a),null):(a.skipToEnd(),c(b,B),"comment");return c(b,A,{start:!0}),d}function A(a,b){var c="body";return!b.ctx.start||a.sol()?D(a,b,c):(a.skipToEnd(),d(b),c)}function B(a,b){return D(a,b,"comment")}function C(a,b){return h?a.sol()?(a.eatSpace()||e(b,a),null):h.token(a,b.ctx.local):D(a,b,"meta")}function D(a,b,c){return a.eol()||a.eatSpace()?(a.skipToEnd(),c):(e(b,a),null)}var h=g(b.verbatim),i=g("python"),j=/^[!"#$%&'()*+,-./:;<=>?@[\\\]^_`{|}~]/,k=/^\s*\w([-:.\w]*\w)?::(\s|$)/,l=/^\s*_[\w-]+:(\s|$)/,m=/^\s*\[(\d+|#)\](\s|$)/,n=/^\s*\[[A-Za-z][\w-]*\](\s|$)/,o=/^\[(\d+|#)\]_/,p=/^\[[A-Za-z][\w-]*\]_/,q=/^\.\.(\s|$)/,r=/^::\s*$/,s=/^[-\s"([{</:]/,t=/^[-\s`'")\]}>/:.,;!?\\_]/,u=/^\s*((\d+|[A-Za-z#])[.)]|\((\d+|[A-Z-a-z#])\))\s/,v=/^\s*[-\+\*]\s/,w=/^\s+(>>>|In \[\d+\]:)\s/;return{startState:function(){return{fn:x,ctx:{}}},copyState:function(a){return{fn:a.fn,ctx:a.ctx}},token:function(a,b){var c=b.fn(a,b);return c}}}),CodeMirror.defineMIME("text/x-rst","rst")