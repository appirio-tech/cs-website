// Quick and dirty spec file highlighting
CodeMirror.defineMode("spec",function(a,b){var c=/^(i386|i586|i686|x86_64|ppc64|ppc|ia64|s390x|s390|sparc64|sparcv9|sparc|noarch|alphaev6|alpha|hppa|mipsel)/,d=/^(Name|Version|Release|License|Summary|Url|Group|Source|BuildArch|BuildRequires|BuildRoot|AutoReqProv|Provides|Requires(\(\w+\))?|Obsoletes|Conflicts|Recommends|Source\d*|Patch\d*|ExclusiveArch|NoSource|Supplements):/,e=/^%(debug_package|package|description|prep|build|install|files|clean|changelog|preun|postun|pre|post|triggerin|triggerun|pretrans|posttrans|verifyscript|check|triggerpostun|triggerprein|trigger)/,f=/^%(ifnarch|ifarch|if)/,g=/^%(else|endif)/,h=/^(\!|\?|\<\=|\<|\>\=|\>|\=\=|\&\&|\|\|)/;return{startState:function(){return{controlFlow:!1,macroParameters:!1,section:!1}},token:function(a,b){var i=a.peek();if(i=="#")return a.skipToEnd(),"comment";if(a.sol()){if(a.match(d))return"preamble";if(a.match(e))return"section"}if(a.match(/^\$\w+/))return"def";if(a.match(/^\$\{\w+\}/))return"def";if(a.match(g))return"keyword";if(a.match(f))return b.controlFlow=!0,"keyword";if(b.controlFlow){if(a.match(h))return"operator";if(a.match(/^(\d+)/))return"number";a.eol()&&(b.controlFlow=!1)}if(a.match(c))return"number";if(a.match(/^%[\w]+/))return a.match(/^\(/)&&(b.macroParameters=!0),"macro";if(b.macroParameters){if(a.match(/^\d+/))return"number";if(a.match(/^\)/))return b.macroParameters=!1,"macro"}return a.match(/^%\{\??[\w \-]+\}/)?"macro":(a.next(),null)}}}),CodeMirror.defineMIME("text/x-rpm-spec","spec")