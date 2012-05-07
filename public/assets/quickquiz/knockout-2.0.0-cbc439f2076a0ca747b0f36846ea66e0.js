// Knockout JavaScript library v2.0.0
// (c) Steven Sanderson - http://knockoutjs.com/
// License: MIT (http://www.opensource.org/licenses/mit-license.php)
(function(a,b){function c(a){throw a}function j(a,b){return a&&"object"==typeof a?b=a:(b=b||{},b.read=a||b.read),"function"!=typeof b.read&&c("Pass a function that returns the value of the dependentObservable"),b}function k(a,b,c){c&&b!==h.h.q(a)&&h.h.S(a,b),b!==h.h.q(a)&&h.a.sa(a,"change")}var d=void 0,e=!0,f=null,g=!1,h=a.ko={};h.b=function(b,c){for(var d=b.split("."),e=a,f=0;f<d.length-1;f++)e=e[d[f]];e[d[d.length-1]]=c},h.l=function(a,b,c){a[b]=c},h.a=new function(){function b(a,b){if("INPUT"!=a.tagName||!a.type)return g;if("click"!=b.toLowerCase())return g;var c=a.type.toLowerCase();return"checkbox"==c||"radio"==c}var i=/^(\s|\u00A0)+|(\s|\u00A0)+$/g,j={},k={};j[/Firefox\/2/i.test(navigator.userAgent)?"KeyboardEvent":"UIEvents"]=["keyup","keydown","keypress"],j.MouseEvents="click,dblclick,mousedown,mouseup,mousemove,mouseover,mouseout,mouseenter,mouseleave".split(",");for(var n in j){var q=j[n];if(q.length)for(var s=0,t=q.length;s<t;s++)k[q[s]]=n}var u=function(){for(var a=3,b=document.createElement("div"),c=b.getElementsByTagName("i");b.innerHTML="<!--[if gt IE "+ ++a+"]><i></i><![endif]-->",c[0];);return 4<a?a:d}();return{Ba:["authenticity_token",/^__RequestVerificationToken(_.*)?$/],n:function(a,b){for(var c=0,d=a.length;c<d;c++)b(a[c])},k:function(a,b){if("function"==typeof Array.prototype.indexOf)return Array.prototype.indexOf.call(a,b);for(var c=0,d=a.length;c<d;c++)if(a[c]===b)return c;return-1},Wa:function(a,b,c){for(var d=0,e=a.length;d<e;d++)if(b.call(c,a[d]))return a[d];return f},ca:function(a,b){var c=h.a.k(a,b);0<=c&&a.splice(c,1)},ya:function(a){for(var a=a||[],b=[],c=0,d=a.length;c<d;c++)0>h.a.k(b,a[c])&&b.push(a[c]);return b},ba:function(a,b){for(var a=a||[],c=[],d=0,e=a.length;d<e;d++)c.push(b(a[d]));return c},aa:function(a,b){for(var a=a||[],c=[],d=0,e=a.length;d<e;d++)b(a[d])&&c.push(a[d]);return c},J:function(a,b){for(var c=0,d=b.length;c<d;c++)a.push(b[c]);return a},extend:function(a,b){for(var c in b)b.hasOwnProperty(c)&&(a[c]=b[c]);return a},U:function(a){for(;a.firstChild;)h.removeNode(a.firstChild)},oa:function(a,b){h.a.U(a),b&&h.a.n(b,function(b){a.appendChild(b)})},Ja:function(a,b){var c=a.nodeType?[a]:a;if(0<c.length){for(var d=c[0],e=d.parentNode,f=0,g=b.length;f<g;f++)e.insertBefore(b[f],d);f=0;for(g=c.length;f<g;f++)h.removeNode(c[f])}},La:function(a,b){0<=navigator.userAgent.indexOf("MSIE 6")?a.setAttribute("selected",b):a.selected=b},z:function(a){return(a||"").replace(i,"")},Db:function(a,b){for(var c=[],d=(a||"").split(b),e=0,f=d.length;e<f;e++){var g=h.a.z(d[e]);""!==g&&c.push(g)}return c},Cb:function(a,b){return a=a||"",b.length>a.length?g:a.substring(0,b.length)===b},hb:function(a){for(var b=Array.prototype.slice.call(arguments,1),c="return ("+a+")",d=0;d<b.length;d++)b[d]&&"object"==typeof b[d]&&(c="with(sc["+d+"]) { "+c+" } ");return(new Function("sc",c))(b)},fb:function(a,b){if(b.compareDocumentPosition)return 16==(b.compareDocumentPosition(a)&16);for(;a!=f;){if(a==b)return e;a=a.parentNode}return g},ga:function(a){return h.a.fb(a,document)},s:function(a,d,f){if("undefined"!=typeof jQuery){if(b(a,d))var h=f,f=function(a,b){var c=this.checked;b&&(this.checked=b.Ya!==e),h.call(this,a),this.checked=c};jQuery(a).bind(d,f)}else"function"==typeof a.addEventListener?a.addEventListener(d,f,g):"undefined"!=typeof a.attachEvent?a.attachEvent("on"+d,function(b){f.call(a,b)}):c(Error("Browser doesn't support addEventListener or attachEvent"))},sa:function(d,f){(!d||!d.nodeType)&&c(Error("element must be a DOM node when calling triggerEvent"));if("undefined"!=typeof jQuery){var h=[];b(d,f)&&h.push({Ya:d.checked}),jQuery(d).trigger(f,h)}else"function"==typeof document.createEvent?"function"==typeof d.dispatchEvent?(h=document.createEvent(k[f]||"HTMLEvents"),h.initEvent(f,e,e,a,0,0,0,0,0,g,g,g,g,0,d),d.dispatchEvent(h)):c(Error("The supplied element doesn't support dispatchEvent")):"undefined"!=typeof d.fireEvent?("click"==f&&"INPUT"==d.tagName&&("checkbox"==d.type.toLowerCase()||"radio"==d.type.toLowerCase())&&(d.checked=d.checked!==e),d.fireEvent("on"+f)):c(Error("Browser doesn't support triggering events"))},d:function(a){return h.V(a)?a():a},eb:function(a,b){return 0<=h.a.k((a.className||"").split(/\s+/),b)},Qa:function(a,b,c){var d=h.a.eb(a,b);if(c&&!d)a.className=(a.className||"")+" "+b;else if(d&&!c){for(var c=(a.className||"").split(/\s+/),d="",e=0;e<c.length;e++)c[e]!=b&&(d+=c[e]+" ");a.className=h.a.z(d)}},outerHTML:function(b){if(u===d){var c=b.outerHTML;if("string"==typeof c)return c}return c=a.document.createElement("div"),c.appendChild(b.cloneNode(e)),c.innerHTML},Ma:function(a,b){var c=h.a.d(b);if(c===f||c===d)c="";"innerText"in a?a.innerText=c:a.textContent=c,9<=u&&(a.innerHTML=a.innerHTML)},yb:function(a,b){for(var a=h.a.d(a),b=h.a.d(b),c=[],d=a;d<=b;d++)c.push(d);return c},X:function(a){for(var b=[],c=0,d=a.length;c<d;c++)b.push(a[c]);return b},ob:6===u,pb:7===u,Ca:function(a,b){for(var c=h.a.X(a.getElementsByTagName("INPUT")).concat(h.a.X(a.getElementsByTagName("TEXTAREA"))),d="string"==typeof b?function(a){return a.name===b}:function(a){return b.test(a.name)},e=[],f=c.length-1;0<=f;f--)d(c[f])&&e.push(c[f]);return e},vb:function(b){return"string"==typeof b&&(b=h.a.z(b))?a.JSON&&a.JSON.parse?a.JSON.parse(b):(new Function("return "+b))():f},qa:function(a){return("undefined"==typeof JSON||"undefined"==typeof JSON.stringify)&&c(Error("Cannot find JSON.stringify(). Some browsers (e.g., IE < 8) don't support it natively, but you can overcome this by adding a script reference to json2.js, downloadable from http://www.json.org/json2.js")),JSON.stringify(h.a.d(a))},wb:function(a,b,c){var c=c||{},d=c.params||{},e=c.includeFields||this.Ba,f=a;if("object"==typeof a&&"FORM"==a.tagName)for(var f=a.action,g=e.length-1;0<=g;g--)for(var i=h.a.Ca(a,e[g]),j=i.length-1;0<=j;j--)d[i[j].name]=i[j].value;var b=h.a.d(b),k=document.createElement("FORM");k.style.display="none",k.action=f,k.method="post";for(var l in b)a=document.createElement("INPUT"),a.name=l,a.value=h.a.qa(h.a.d(b[l])),k.appendChild(a);for(l in d)a=document.createElement("INPUT"),a.name=l,a.value=d[l],k.appendChild(a);document.body.appendChild(k),c.submitter?c.submitter(k):k.submit(),setTimeout(function(){k.parentNode.removeChild(k)},0)}}},h.b("ko.utils",h.a),h.a.n([["arrayForEach",h.a.n],["arrayFirst",h.a.Wa],["arrayFilter",h.a.aa],["arrayGetDistinctValues",h.a.ya],["arrayIndexOf",h.a.k],["arrayMap",h.a.ba],["arrayPushAll",h.a.J],["arrayRemoveItem",h.a.ca],["extend",h.a.extend],["fieldsIncludedWithJsonPost",h.a.Ba],["getFormFields",h.a.Ca],["postJson",h.a.wb],["parseJson",h.a.vb],["registerEventHandler",h.a.s],["stringifyJson",h.a.qa],["range",h.a.yb],["toggleDomNodeCssClass",h.a.Qa],["triggerEvent",h.a.sa],["unwrapObservable",h.a.d]],function(a){h.b("ko.utils."+a[0],a[1])}),Function.prototype.bind||(Function.prototype.bind=function(a){var b=this,c=Array.prototype.slice.call(arguments),a=c.shift();return function(){return b.apply(a,c.concat(Array.prototype.slice.call(arguments)))}}),h.a.e=new function(){var a=0,b="__ko__"+(new Date).getTime(),c={};return{get:function(a,b){var c=h.a.e.getAll(a,g);return c===d?d:c[b]},set:function(a,b,c){c===d&&h.a.e.getAll(a,g)===d||(h.a.e.getAll(a,e)[b]=c)},getAll:function(d,e){var f=d[b];if(!f||"null"===f){if(!e)return;f=d[b]="ko"+a++,c[f]={}}return c[f]},clear:function(a){var d=a[b];d&&(delete c[d],a[b]=f)}}},h.b("ko.utils.domData",h.a.e),h.b("ko.utils.domData.clear",h.a.e.clear),h.a.A=new function(){function a(a,b){var c=h.a.e.get(a,f);return c===d&&b&&(c=[],h.a.e.set(a,f,c)),c}function b(b){var c=a(b,g);if(c)for(var c=c.slice(0),d=0;d<c.length;d++)c[d](b);h.a.e.clear(b),"function"==typeof jQuery&&"function"==typeof jQuery.cleanData&&jQuery.cleanData([b])}var f="__ko_domNodeDisposal__"+(new Date).getTime();return{va:function(b,d){"function"!=typeof d&&c(Error("Callback must be a function")),a(b,e).push(d)},Ia:function(b,c){var e=a(b,g);e&&(h.a.ca(e,c),0==e.length&&h.a.e.set(b,f,d))},F:function(a){if(1==a.nodeType||9==a.nodeType){b(a);var c=[];h.a.J(c,a.getElementsByTagName("*"));for(var a=0,d=c.length;a<d;a++)b(c[a])}},removeNode:function(a){h.F(a),a.parentNode&&a.parentNode.removeChild(a)}}},h.F=h.a.A.F,h.removeNode=h.a.A.removeNode,h.b("ko.cleanNode",h.F),h.b("ko.removeNode",h.removeNode),h.b("ko.utils.domNodeDisposal",h.a.A),h.b("ko.utils.domNodeDisposal.addDisposeCallback",h.a.A.va),h.b("ko.utils.domNodeDisposal.removeDisposeCallback",h.a.A.Ia),h.a.ma=function(b){var c;if("undefined"!=typeof jQuery){if((c=jQuery.clean([b]))&&c[0]){for(b=c[0];b.parentNode&&11!==b.parentNode.nodeType;)b=b.parentNode;b.parentNode&&b.parentNode.removeChild(b)}}else{var d=h.a.z(b).toLowerCase();c=document.createElement("div"),d=d.match(/^<(thead|tbody|tfoot)/)&&[1,"<table>","</table>"]||!d.indexOf("<tr")&&[2,"<table><tbody>","</tbody></table>"]||(!d.indexOf("<td")||!d.indexOf("<th"))&&[3,"<table><tbody><tr>","</tr></tbody></table>"]||[0,"",""],b="ignored<div>"+d[1]+b+d[2]+"</div>";for("function"==typeof a.innerShiv?c.appendChild(a.innerShiv(b)):c.innerHTML=b;d[0]--;)c=c.lastChild;c=h.a.X(c.lastChild.childNodes)}return c},h.a.Z=function(a,b){h.a.U(a);if(b!==f&&b!==d)if("string"!=typeof b&&(b=b.toString()),"undefined"!=typeof jQuery)jQuery(a).html(b);else for(var c=h.a.ma(b),e=0;e<c.length;e++)a.appendChild(c[e])},h.b("ko.utils.parseHtmlFragment",h.a.ma),h.b("ko.utils.setHtml",h.a.Z),h.r=function(){function a(){return(4294967296*(1+Math.random())|0).toString(16).substring(1)}function b(a,c){if(a)if(8==a.nodeType){var d=h.r.Ga(a.nodeValue);d!=f&&c.push({cb:a,tb:d})}else if(1==a.nodeType)for(var d=0,e=a.childNodes,g=e.length;d<g;d++)b(e[d],c)}var g={};return{ka:function(b){"function"!=typeof b&&c(Error("You can only pass a function to ko.memoization.memoize()"));var d=a()+a();return g[d]=b,"<!--[ko_memo:"+d+"]-->"},Ra:function(a,b){var h=g[a];h===d&&c(Error("Couldn't find any memo with ID "+a+". Perhaps it's already been unmemoized."));try{return h.apply(f,b||[]),e}finally{delete g[a]}},Sa:function(a,c){var d=[];b(a,d);for(var e=0,f=d.length;e<f;e++){var g=d[e].cb,i=[g];c&&h.a.J(i,c),h.r.Ra(d[e].tb,i),g.nodeValue="",g.parentNode&&g.parentNode.removeChild(g)}},Ga:function(a){return(a=a.match(/^\[ko_memo\:(.*?)\]$/))?a[1]:f}}}(),h.b("ko.memoization",h.r),h.b("ko.memoization.memoize",h.r.ka),h.b("ko.memoization.unmemoize",h.r.Ra),h.b("ko.memoization.parseMemoText",h.r.Ga),h.b("ko.memoization.unmemoizeDomNodeAndDescendants",h.r.Sa),h.Aa={throttle:function(a,b){a.throttleEvaluation=b;var c=f;return h.i({read:a,write:function(d){clearTimeout(c),c=setTimeout(function(){a(d)},b)}})},notify:function(a,b){return a.equalityComparer="always"==b?function(){return g}:h.w.fn.equalityComparer,a}},h.b("ko.extenders",h.Aa),h.Oa=function(a,b){this.da=a,this.bb=b,h.l(this,"dispose",this.v)},h.Oa.prototype.v=function(){this.nb=e,this.bb()},h.R=function(){this.u={},h.a.extend(this,h.R.fn),h.l(this,"subscribe",this.ra),h.l(this,"extend",this.extend),h.l(this,"getSubscriptionsCount",this.kb)},h.R.fn={ra:function(a,b,c){var c=c||"change",a=b?a.bind(b):a,d=new h.Oa(a,function(){h.a.ca(this.u[c],d)}.bind(this));return this.u[c]||(this.u[c]=[]),this.u[c].push(d),d},notifySubscribers:function(a,b){b=b||"change",this.u[b]&&h.a.n(this.u[b].slice(0),function(b){b&&b.nb!==e&&b.da(a)})},kb:function(){var a=0,b;for(b in this.u)this.u.hasOwnProperty(b)&&(a+=this.u[b].length);return a},extend:function(a){var b=this;if(a)for(var c in a){var d=h.Aa[c];"function"==typeof d&&(b=d(b,a[c]))}return b}},h.Ea=function(a){return"function"==typeof a.ra&&"function"==typeof a.notifySubscribers},h.b("ko.subscribable",h.R),h.b("ko.isSubscribable",h.Ea),h.T=function(){var a=[];return{Xa:function(b){a.push({da:b,za:[]})},end:function(){a.pop()},Ha:function(b){h.Ea(b)||c("Only subscribable things can act as dependencies");if(0<a.length){var d=a[a.length-1];0<=h.a.k(d.za,b)||(d.za.push(b),d.da(b))}}}}();var i={"undefined":e,"boolean":e,number:e,string:e};h.w=function(a){function b(){if(0<arguments.length){if(!b.equalityComparer||!b.equalityComparer(c,arguments[0]))b.H(),c=arguments[0],b.G();return this}return h.T.Ha(b),c}var c=a;return h.R.call(b),b.G=function(){b.notifySubscribers(c)},b.H=function(){b.notifySubscribers(c,"beforeChange")},h.a.extend(b,h.w.fn),h.l(b,"valueHasMutated",b.G),h.l(b,"valueWillMutate",b.H),b},h.w.fn={B:h.w,equalityComparer:function(a,b){return a===f||typeof a in i?a===b:g}},h.V=function(a){return a===f||a===d||a.B===d?g:a.B===h.w?e:h.V(a.B)},h.P=function(a){return"function"==typeof a&&a.B===h.w?e:"function"==typeof a&&a.B===h.i&&a.lb?e:g},h.b("ko.observable",h.w),h.b("ko.isObservable",h.V),h.b("ko.isWriteableObservable",h.P),h.Q=function(a){0==arguments.length&&(a=[]),a!==f&&a!==d&&!("length"in a)&&c(Error("The argument passed when initializing an observable array must be an array, or null, or undefined."));var b=new h.w(a);return h.a.extend(b,h.Q.fn),h.l(b,"remove",b.remove),h.l(b,"removeAll",b.zb),h.l(b,"destroy",b.fa),h.l(b,"destroyAll",b.ab),h.l(b,"indexOf",b.indexOf),h.l(b,"replace",b.replace),b},h.Q.fn={remove:function(a){for(var b=this(),c=[],d="function"==typeof a?a:function(b){return b===a},e=0;e<b.length;e++){var f=b[e];d(f)&&(0===c.length&&this.H(),c.push(f),b.splice(e,1),e--)}return c.length&&this.G(),c},zb:function(a){if(a===d){var b=this(),c=b.slice(0);return this.H(),b.splice(0,b.length),this.G(),c}return a?this.remove(function(b){return 0<=h.a.k(a,b)}):[]},fa:function(a){var b=this(),c="function"==typeof a?a:function(b){return b===a};this.H();for(var d=b.length-1;0<=d;d--)c(b[d])&&(b[d]._destroy=e);this.G()},ab:function(a){return a===d?this.fa(function(){return e}):a?this.fa(function(b){return 0<=h.a.k(a,b)}):[]},indexOf:function(a){var b=this();return h.a.k(b,a)},replace:function(a,b){var c=this.indexOf(a);0<=c&&(this.H(),this()[c]=b,this.G())}},h.a.n("pop,push,reverse,shift,sort,splice,unshift".split(","),function(a){h.Q.fn[a]=function(){var b=this();return this.H(),b=b[a].apply(b,arguments),this.G(),b}}),h.a.n(["slice"],function(a){h.Q.fn[a]=function(){var b=this();return b[a].apply(b,arguments)}}),h.b("ko.observableArray",h.Q),h.i=function(a,b,d){function i(){h.a.n(w,function(a){a.v()}),w=[]}function k(){var a=n.throttleEvaluation;a&&0<=a?(clearTimeout(x),x=setTimeout(l,a)):l()}function l(){if(s&&"function"==typeof d.disposeWhen&&d.disposeWhen())n.v();else{try{i(),h.T.Xa(function(a){w.push(a.ra(k))});var a=d.read.call(d.owner||b);n.notifySubscribers(q,"beforeChange"),q=a}finally{h.T.end()}n.notifySubscribers(q),s=e}}function n(){if(0<arguments.length)"function"==typeof d.write?d.write.apply(d.owner||b,arguments):c("Cannot write a value to a dependentObservable unless you specify a 'write' option. If you wish to read the current value, don't pass any parameters.");else return s||l(),h.T.Ha(n),q}var q,s=g,d=j(a,d),t="object"==typeof d.disposeWhenNodeIsRemoved?d.disposeWhenNodeIsRemoved:f,u=f;if(t){u=function(){n.v()},h.a.A.va(t,u);var v=d.disposeWhen;d.disposeWhen=function(){return!h.a.ga(t)||"function"==typeof v&&v()}}var w=[],x=f;return n.jb=function(){return w.length},n.lb="function"==typeof d.write,n.v=function(){t&&h.a.A.Ia(t,u),i()},h.R.call(n),h.a.extend(n,h.i.fn),d.deferEvaluation!==e&&l(),h.l(n,"dispose",n.v),h.l(n,"getDependenciesCount",n.jb),n},h.i.fn={B:h.i},h.i.B=h.w,h.b("ko.dependentObservable",h.i),h.b("ko.computed",h.i),function(){function a(c,g,h){h=h||new e,c=g(c);if("object"!=typeof c||c===f||c===d||c instanceof Date)return c;var i=c instanceof Array?[]:{};return h.save(c,i),b(c,function(b){var e=g(c[b]);switch(typeof e){case"boolean":case"number":case"string":case"function":i[b]=e;break;case"object":case"undefined":var f=h.get(e);i[b]=f!==d?f:a(e,g,h)}}),i}function b(a,b){if(a instanceof Array)for(var c=0;c<a.length;c++)b(c);else for(c in a)b(c)}function e(){var a=[],b=[];this.save=function(c,d){var e=h.a.k(a,c);0<=e?b[e]=d:(a.push(c),b.push(d))},this.get=function(c){return c=h.a.k(a,c),0<=c?b[c]:d}}h.Pa=function(b){return 0==arguments.length&&c(Error("When calling ko.toJS, pass the object you want to convert.")),a(b,function(a){for(var b=0;h.V(a)&&10>b;b++)a=a();return a})},h.toJSON=function(a){return a=h.Pa(a),h.a.qa(a)}}(),h.b("ko.toJS",h.Pa),h.b("ko.toJSON",h.toJSON),h.h={q:function(a){return"OPTION"==a.tagName?a.__ko__hasDomDataOptionValue__===e?h.a.e.get(a,h.c.options.la):a.getAttribute("value"):"SELECT"==a.tagName?0<=a.selectedIndex?h.h.q(a.options[a.selectedIndex]):d:a.value},S:function(a,b){if("OPTION"==a.tagName)switch(typeof b){case"string":h.a.e.set(a,h.c.options.la,d),"__ko__hasDomDataOptionValue__"in a&&delete a.__ko__hasDomDataOptionValue__,a.value=b;break;default:h.a.e.set(a,h.c.options.la,b),a.__ko__hasDomDataOptionValue__=e,a.value="number"==typeof b?b:""}else if("SELECT"==a.tagName){for(var c=a.options.length-1;0<=c;c--)if(h.h.q(a.options[c])==b){a.selectedIndex=c;break}}else{if(b===f||b===d)b="";a.value=b}}},h.b("ko.selectExtensions",h.h),h.b("ko.selectExtensions.readValue",h.h.q),h.b("ko.selectExtensions.writeValue",h.h.S),h.j=function(){function a(a,c){for(var d=f;a!=d;)d=a,a=a.replace(b,function(a,b){return c[b]});return a}var b=/\@ko_token_(\d+)\@/g,c=/^[\_$a-z][\_$a-z0-9]*(\[.*?\])*(\.[\_$a-z][\_$a-z0-9]*(\[.*?\])*)*$/i,d=["true","false"];return{D:[],Y:function(b){var c=h.a.z(b);if(3>c.length)return[];"{"===c.charAt(0)&&(c=c.substring(1,c.length-1));for(var b=[],d=f,e,g=0;g<c.length;g++){var i=c.charAt(g);if(d===f)switch(i){case'"':case"'":case"/":d=g,e=i}else if(i==e&&"\\"!==c.charAt(g-1)){i=c.substring(d,g+1),b.push(i);var j="@ko_token_"+(b.length-1)+"@",c=c.substring(0,d)+j+c.substring(g+1),g=g-(i.length-j.length),d=f}}e=d=f;for(var k=0,l=f,g=0;g<c.length;g++){i=c.charAt(g);if(d===f)switch(i){case"{":d=g,l=i,e="}";break;case"(":d=g,l=i,e=")";break;case"[":d=g,l=i,e="]"}i===l?k++:i===e&&(k--,0===k&&(i=c.substring(d,g+1),b.push(i),j="@ko_token_"+(b.length-1)+"@",c=c.substring(0,d)+j+c.substring(g+1),g-=i.length-j.length,d=f))}e=[],c=c.split(","),d=0;for(g=c.length;d<g;d++)k=c[d],l=k.indexOf(":"),0<l&&l<k.length-1?(i=k.substring(l+1),e.push({key:a(k.substring(0,l),b),value:a(i,b)})):e.push({unknown:a(k,b)});return e},ia:function(a){for(var b="string"==typeof a?h.j.Y(a):a,e=[],a=[],g,i=0;g=b[i];i++)if(0<e.length&&e.push(","),g.key){var j;a:{j=g.key;var k=h.a.z(j);switch(k.length&&k.charAt(0)){case"'":case'"':break a;default:j="'"+k+"'"}}g=g.value,e.push(j),e.push(":"),e.push(g),k=h.a.z(g);if(0<=h.a.k(d,h.a.z(k).toLowerCase())?0:k.match(c)!==f)0<a.length&&a.push(", "),a.push(j+" : function(__ko_value) { "+g+" = __ko_value; }")}else g.unknown&&e.push(g.unknown);return b=e.join(""),0<a.length&&(b=b+", '_ko_property_writers' : { "+a.join("")+" } "),b},rb:function(a,b){for(var c=0;c<a.length;c++)if(h.a.z(a[c].key)==b)return e;return g}}}(),h.b("ko.jsonExpressionRewriting",h.j),h.b("ko.jsonExpressionRewriting.bindingRewriteValidators",h.j.D),h.b("ko.jsonExpressionRewriting.parseObjectLiteral",h.j.Y),h.b("ko.jsonExpressionRewriting.insertPropertyAccessorsIntoJson",h.j.ia),function(){function a(a){return 8==a.nodeType&&(j?a.text:a.nodeValue).match(k)}function b(a){return 8==a.nodeType&&(j?a.text:a.nodeValue).match(n)}function g(d,e){for(var g=d,h=1,i=[];g=g.nextSibling;){if(b(g)&&(h--,0===h))return i;i.push(g),a(g)&&h++}return e||c(Error("Cannot find closing comment tag to match: "+d.nodeValue)),f}function i(a,b){var c=g(a,b);return c?0<c.length?c[c.length-1].nextSibling:a.nextSibling:f}var j="<!--test-->"===document.createComment("test").text,k=j?/^<\!--\s*ko\s+(.*\:.*)\s*--\>$/:/^\s*ko\s+(.*\:.*)\s*$/,n=j?/^<\!--\s*\/ko\s*--\>$/:/^\s*\/ko\s*$/,p={ul:e,ol:e};h.f={C:{},childNodes:function(b){return a(b)?g(b):b.childNodes},ha:function(b){if(a(b))for(var b=h.f.childNodes(b),c=0,d=b.length;c<d;c++)h.removeNode(b[c]);else h.a.U(b)},oa:function(b,c){if(a(b)){h.f.ha(b);for(var d=b.nextSibling,e=0,f=c.length;e<f;e++)d.parentNode.insertBefore(c[e],d)}else h.a.oa(b,c)},xb:function(b,c){a(b)?b.parentNode.insertBefore(c,b.nextSibling):b.firstChild?b.insertBefore(c,b.firstChild):b.appendChild(c)},mb:function(b,c,d){a(b)?b.parentNode.insertBefore(c,d.nextSibling):d.nextSibling?b.insertBefore(c,d.nextSibling):b.appendChild(c)},nextSibling:function(c){return a(c)?i(c).nextSibling:c.nextSibling&&b(c.nextSibling)?d:c.nextSibling},ta:function(b){return(b=a(b))?b[1]:f},ib:function(a){if(h.f.ta(a)){var b;b=h.f.childNodes(a);for(var c=[],d=0,e=b.length;d<e;d++)h.a.A.F(b[d]),c.push(h.a.outerHTML(b[d]));b=String.prototype.concat.apply("",c),h.f.ha(a),(new h.m.I(a)).text(b)}},Fa:function(c){if(p[c.tagName.toLowerCase()]){var d=c.firstChild;if(d)do if(1===d.nodeType){var g;g=d.firstChild;var h=f;if(g)do if(h)h.push(g);else if(a(g)){var j=i(g,e);j?g=j:h=[g]}else b(g)&&(h=[g]);while(g=g.nextSibling);if(g=h){h=d.nextSibling;for(j=0;j<g.length;j++)h?c.insertBefore(g[j],h):c.appendChild(g[j])}}while(d=d.nextSibling)}}}}(),h.L=function(){},h.a.extend(h.L.prototype,{nodeHasBindings:function(a){switch(a.nodeType){case 1:return a.getAttribute("data-bind")!=f;case 8:return h.f.ta(a)!=f;default:return g}},getBindings:function(a,b){var c=this.getBindingsString(a,b);return c?this.parseBindingsString(c,b):f},getBindingsString:function(a){switch(a.nodeType){case 1:return a.getAttribute("data-bind");case 8:return h.f.ta(a);default:return f}},parseBindingsString:function(b,d){try{var e=d.$data,g=" { "+h.j.ia(b)+" } ";return h.a.hb(g,e===f?a:e,d)}catch(i){c(Error("Unable to parse bindings.\nMessage: "+i+";\nBindings value: "+b))}}}),h.L.instance=new h.L,h.b("ko.bindingProvider",h.L),function(){function b(a,b){for(var c,d=b.childNodes[0];c=d;)d=h.f.nextSibling(c),i(a,c,g)}function i(a,c,d){var g=e,i=1==c.nodeType;i&&h.f.Fa(c);if(i&&d||h.L.instance.nodeHasBindings(c))g=j(c,f,a,d).Bb;i&&g&&b(a,c)}function j(a,b,e,g){function i(a){return function(){return m[a]}}function j(){return m}var k=0;h.f.ib(a);var m,n;return new h.i(function(){var f=e&&e instanceof h.K?e:new h.K(h.a.d(e)),o=f.$data;g&&h.Na(a,f);if(m=("function"==typeof b?b():b)||h.L.instance.getBindings(a,f)){if(0===k){k=1;for(var p in m){var q=h.c[p];q&&8===a.nodeType&&!h.f.C[p]&&c(Error("The binding '"+p+"' cannot be used with virtual elements")),q&&"function"==typeof q.init&&(q=(0,q.init)(a,i(p),j,o,f))&&q.controlsDescendantBindings&&(n!==d&&c(Error("Multiple bindings ("+n+" and "+p+") are trying to control descendant bindings of the same element. You cannot use these bindings together on the same element.")),n=p)}k=2}if(2===k)for(p in m)(q=h.c[p])&&"function"==typeof q.update&&(0,q.update)(a,i(p),j,o,f)}},f,{disposeWhenNodeIsRemoved:a}),{Bb:n===d}}h.c={},h.K=function(a,b){this.$data=a,b?(this.$parent=b.$data,this.$parents=(b.$parents||[]).slice(0),this.$parents.unshift(this.$parent),this.$root=b.$root):(this.$parents=[],this.$root=a)},h.K.prototype.createChildContext=function(a){return new h.K(a,this)},h.Na=function(a,b){if(2==arguments.length)h.a.e.set(a,"__ko_bindingContext__",b);else return h.a.e.get(a,"__ko_bindingContext__")},h.xa=function(a,b,c){return 1===a.nodeType&&h.f.Fa(a),j(a,b,c,e)},h.Ta=function(a,c){1===c.nodeType&&b(a,c)},h.wa=function(b,d){d&&1!==d.nodeType&&8!==d.nodeType&&c(Error("ko.applyBindings: first parameter should be your view model; second parameter should be a DOM node")),d=d||a.document.body,i(b,d,e)},h.ea=function(a){switch(a.nodeType){case 1:case 8:var b=h.Na(a);if(b)return b;if(a.parentNode)return h.ea(a.parentNode)}},h.$a=function(a){return(a=h.ea(a))?a.$data:d},h.b("ko.bindingHandlers",h.c),h.b("ko.applyBindings",h.wa),h.b("ko.applyBindingsToDescendants",h.Ta),h.b("ko.applyBindingsToNode",h.xa),h.b("ko.contextFor",h.ea),h.b("ko.dataFor",h.$a)}(),h.a.n(["click"],function(a){h.c[a]={init:function(b,c,d,e){return h.c.event.init.call(this,b,function(){var b={};return b[a]=c(),b},d,e)}}}),h.c.event={init:function(a,b,c,d){var f=b()||{},i;for(i in f)(function(){var f=i;"string"==typeof f&&h.a.s(a,f,function(a){var i,j=b()[f];if(j){var k=c();try{var l=h.a.X(arguments);l.unshift(d),i=j.apply(d,l)}finally{i!==e&&(a.preventDefault?a.preventDefault():a.returnValue=g)}k[f+"Bubble"]===g&&(a.cancelBubble=e,a.stopPropagation&&a.stopPropagation())}})})()}},h.c.submit={init:function(a,b,d,f){"function"!=typeof b()&&c(Error("The value for a submit binding must be a function")),h.a.s(a,"submit",function(c){var d,h=b();try{d=h.call(f,a)}finally{d!==e&&(c.preventDefault?c.preventDefault():c.returnValue=g)}})}},h.c.visible={update:function(a,b){var c=h.a.d(b()),d="none"!=a.style.display;c&&!d?a.style.display="":!c&&d&&(a.style.display="none")}},h.c.enable={update:function(a,b){var c=h.a.d(b());c&&a.disabled?a.removeAttribute("disabled"):!c&&!a.disabled&&(a.disabled=e)}},h.c.disable={update:function(a,b){h.c.enable.update(a,function(){return!h.a.d(b())})}},h.c.value={init:function(a,b,c){var d=["change"],f=c().valueUpdate;f&&("string"==typeof f&&(f=[f]),h.a.J(d,f),d=h.a.ya(d)),h.a.n(d,function(d){var f=g;h.a.Cb(d,"after")&&(f=e,d=d.substring(5));var i=f?function(a){setTimeout(a,0)}:function(a){a()};h.a.s(a,d,function(){i(function(){var d=b(),e=h.h.q(a);h.P(d)?d(e):(d=c(),d._ko_property_writers&&d._ko_property_writers.value&&d._ko_property_writers.value(e))})})})},update:function(a,b){var c=h.a.d(b()),d=h.h.q(a),f=c!=d;0===c&&0!==d&&"0"!==d&&(f=e),f&&(d=function(){h.h.S(a,c)},d(),"SELECT"==a.tagName&&setTimeout(d,0)),"SELECT"==a.tagName&&0<a.length&&k(a,c,g)}},h.c.options={update:function(a,b,g){"SELECT"!=a.tagName&&c(Error("options binding applies only to SELECT elements"));var i=0==a.length,j=h.a.ba(h.a.aa(a.childNodes,function(a){return a.tagName&&"OPTION"==a.tagName&&a.selected}),function(a){return h.h.q(a)||a.innerText||a.textContent}),n=a.scrollTop;a.scrollTop=0;for(var p=h.a.d(b());0<a.length;)h.F(a.options[0]),a.remove(0);if(p){g=g(),"number"!=typeof p.length&&(p=[p]);if(g.optionsCaption){var q=document.createElement("OPTION");h.a.Z(q,g.optionsCaption),h.h.S(q,d),a.appendChild(q)}for(var b=0,s=p.length;b<s;b++){var q=document.createElement("OPTION"),t="string"==typeof g.optionsValue?p[b][g.optionsValue]:p[b],t=h.a.d(t);h.h.S(q,t);var u=g.optionsText,t="function"==typeof u?u(p[b]):"string"==typeof u?p[b][u]:t;if(t===f||t===d)t="";h.a.Ma(q,t),a.appendChild(q)}p=a.getElementsByTagName("OPTION"),b=q=0;for(s=p.length;b<s;b++)0<=h.a.k(j,h.h.q(p[b]))&&(h.a.La(p[b],e),q++);n&&(a.scrollTop=n),i&&"value"in g&&k(a,h.a.d(g.value),e)}}},h.c.options.la="__ko.optionValueDomData__",h.c.selectedOptions={Da:function(a){for(var b=[],a=a.childNodes,c=0,d=a.length;c<d;c++){var e=a[c];"OPTION"==e.tagName&&e.selected&&b.push(h.h.q(e))}return b},init:function(a,b,c){h.a.s(a,"change",function(){var a=b();h.P(a)?a(h.c.selectedOptions.Da(this)):(a=c(),a._ko_property_writers&&a._ko_property_writers.value&&a._ko_property_writers.value(h.c.selectedOptions.Da(this)))})},update:function(a,b){"SELECT"!=a.tagName&&c(Error("values binding applies only to SELECT elements"));var d=h.a.d(b());if(d&&"number"==typeof d.length)for(var e=a.childNodes,f=0,g=e.length;f<g;f++){var i=e[f];"OPTION"==i.tagName&&h.a.La(i,0<=h.a.k(d,h.h.q(i)))}}},h.c.text={update:function(a,b){h.a.Ma(a,b())}},h.c.html={init:function(){return{controlsDescendantBindings:e}},update:function(a,b){var c=h.a.d(b());h.a.Z(a,c)}},h.c.css={update:function(a,b){var c=h.a.d(b()||{}),d;for(d in c)if("string"==typeof d){var e=h.a.d(c[d]);h.a.Qa(a,d,e)}}},h.c.style={update:function(a,b){var c=h.a.d(b()||{}),d;for(d in c)if("string"==typeof d){var e=h.a.d(c[d]);a.style[d]=e||""}}},h.c.uniqueName={init:function(a,b){b()&&(a.name="ko_unique_"+ ++h.c.uniqueName.Za,(h.a.ob||h.a.pb)&&a.mergeAttributes(document.createElement("<input name='"+a.name+"'/>"),g))}},h.c.uniqueName.Za=0,h.c.checked={init:function(a,b,c){h.a.s(a,"click",function(){var d;if("checkbox"==a.type)d=a.checked;else if("radio"==a.type&&a.checked)d=a.value;else return;var e=b();"checkbox"==a.type&&h.a.d(e)instanceof Array?(d=h.a.k(h.a.d(e),a.value),a.checked&&0>d?e.push(a.value):!a.checked&&0<=d&&e.splice(d,1)):h.P(e)?e()!==d&&e(d):(e=c(),e._ko_property_writers&&e._ko_property_writers.checked&&e._ko_property_writers.checked(d))}),"radio"==a.type&&!a.name&&h.c.uniqueName.init(a,function(){return e})},update:function(a,b){var c=h.a.d(b());"checkbox"==a.type?a.checked=c instanceof Array?0<=h.a.k(c,a.value):c:"radio"==a.type&&(a.checked=a.value==c)}},h.c.attr={update:function(a,b){var c=h.a.d(b())||{},e;for(e in c)if("string"==typeof e){var i=h.a.d(c[e]);i===g||i===f||i===d?a.removeAttribute(e):a.setAttribute(e,i.toString())}}},h.c.hasfocus={init:function(a,b,c){function d(a){var d=b();a!=h.a.d(d)&&(h.P(d)?d(a):(d=c(),d._ko_property_writers&&d._ko_property_writers.hasfocus&&d._ko_property_writers.hasfocus(a)))}h.a.s(a,"focus",function(){d(e)}),h.a.s(a,"focusin",function(){d(e)}),h.a.s(a,"blur",function(){d(g)}),h.a.s(a,"focusout",function(){d(g)})},update:function(a,b){var c=h.a.d(b());c?a.focus():a.blur(),h.a.sa(a,c?"focusin":"focusout")}},h.c["with"]={o:function(a){return function(){var b=a();return{"if":b,data:b,templateEngine:h.p.M}}},init:function(a,b){return h.c.template.init(a,h.c["with"].o(b))},update:function(a,b,c,d,e){return h.c.template.update(a,h.c["with"].o(b),c,d,e)}},h.j.D["with"]=g,h.f.C["with"]=e,h.c["if"]={o:function(a){return function(){return{"if":a(),templateEngine:h.p.M}}},init:function(a,b){return h.c.template.init(a,h.c["if"].o(b))},update:function(a,b,c,d,e){return h.c.template.update(a,h.c["if"].o(b),c,d,e)}},h.j.D["if"]=g,h.f.C["if"]=e,h.c.ifnot={o:function(a){return function(){return{ifnot:a(),templateEngine:h.p.M}}},init:function(a,b){return h.c.template.init(a,h.c.ifnot.o(b))},update:function(a,b,c,d,e){return h.c.template.update(a,h.c.ifnot.o(b),c,d,e)}},h.j.D.ifnot=g,h.f.C.ifnot=e,h.c.foreach={o:function(a){return function(){var b=h.a.d(a());return!b||"number"==typeof b.length?{foreach:b,templateEngine:h.p.M}:{foreach:b.data,includeDestroyed:b.includeDestroyed,afterAdd:b.afterAdd,beforeRemove:b.beforeRemove,afterRender:b.afterRender,templateEngine:h.p.M}}},init:function(a,b){return h.c.template.init(a,h.c.foreach.o(b))},update:function(a,b,c,d,e){return h.c.template.update(a,h.c.foreach.o(b),c,d,e)}},h.j.D.foreach=g,h.f.C.foreach=e,h.b("ko.allowedVirtualElementBindings",h.f.C),h.t=function(){},h.t.prototype.renderTemplateSource=function(){c("Override renderTemplateSource")},h.t.prototype.createJavaScriptEvaluatorBlock=function(){c("Override createJavaScriptEvaluatorBlock")},h.t.prototype.makeTemplateSource=function(a){if("string"==typeof a){var b=document.getElementById(a);return b||c(Error("Cannot find template with ID "+a)),new h.m.g(b)}if(1==a.nodeType||8==a.nodeType)return new h.m.I(a);c(Error("Unknown template type: "+a))},h.t.prototype.renderTemplate=function(a,b,c){return this.renderTemplateSource(this.makeTemplateSource(a),b,c)},h.t.prototype.isTemplateRewritten=function(a){return this.allowTemplateRewriting===g?e:this.W&&this.W[a]?e:this.makeTemplateSource(a).data("isRewritten")},h.t.prototype.rewriteTemplate=function(a,b){var c=this.makeTemplateSource(a),d=b(c.text());c.text(d),c.data("isRewritten",e),"string"==typeof a&&(this.W=this.W||{},this.W[a]=e)},h.b("ko.templateEngine",h.t),h.$=function(){function a(a,b,d){for(var a=h.j.Y(a),e=h.j.D,f=0;f<a.length;f++){var g=a[f].key;if(e.hasOwnProperty(g)){var i=e[g];"function"==typeof i?(g=i(a[f].value))&&c(Error(g)):i||c(Error("This template engine does not support the '"+g+"' binding within its templates"))}}return a="ko.templateRewriting.applyMemoizedBindingsToNextSibling(function() {             return (function() { return { "+h.j.ia(a)+" } })()         })",d.createJavaScriptEvaluatorBlock(a)+b}var b=/(<[a-z]+\d*(\s+(?!data-bind=)[a-z0-9\-]+(=(\"[^\"]*\"|\'[^\']*\'))?)*\s+)data-bind=(["'])([\s\S]*?)\5/gi,d=/<\!--\s*ko\b\s*([\s\S]*?)\s*--\>/g;return{gb:function(a,b){b.isTemplateRewritten(a)||b.rewriteTemplate(a,function(a){return h.$.ub(a,b)})},ub:function(c,e){return c.replace(b,function(b,c,d,f,g,h,i){return a(i,c,e)}).replace(d,function(b,c){return a(c,"<!-- ko -->",e)})},Ua:function(a){return h.r.ka(function(b,c){b.nextSibling&&h.xa(b.nextSibling,a,c)})}}}(),h.b("ko.templateRewriting",h.$),h.b("ko.templateRewriting.applyMemoizedBindingsToNextSibling",h.$.Ua),h.m={},h.m.g=function(a){this.g=a},h.m.g.prototype.text=function(){if(0==arguments.length)return"script"==this.g.tagName.toLowerCase()?this.g.text:this.g.innerHTML;var a=arguments[0];"script"==this.g.tagName.toLowerCase()?this.g.text=a:h.a.Z(this.g,a)},h.m.g.prototype.data=function(a){if(1===arguments.length)return h.a.e.get(this.g,"templateSourceData_"+a);h.a.e.set(this.g,"templateSourceData_"+a,arguments[1])},h.m.I=function(a){this.g=a},h.m.I.prototype=new h.m.g,h.m.I.prototype.text=function(
){if(0==arguments.length)return h.a.e.get(this.g,"__ko_anon_template__");h.a.e.set(this.g,"__ko_anon_template__",arguments[0])},h.b("ko.templateSources",h.m),h.b("ko.templateSources.domElement",h.m.g),h.b("ko.templateSources.anonymousTemplate",h.m.I),function(){function a(a,b,c){for(var d=0;node=a[d];d++)node.parentNode===b&&(1===node.nodeType||8===node.nodeType)&&c(node)}function b(a,b,d,f,j){var j=j||{},k=j.templateEngine||i;h.$.gb(d,k),d=k.renderTemplate(d,f,j),("number"!=typeof d.length||0<d.length&&"number"!=typeof d[0].nodeType)&&c("Template engine must return an array of DOM nodes"),k=g;switch(b){case"replaceChildren":h.f.oa(a,d),k=e;break;case"replaceNode":h.a.Ja(a,d),k=e;break;case"ignoreTargetNode":break;default:c(Error("Unknown renderMode: "+b))}return k&&(h.ua(d,f),j.afterRender&&j.afterRender(d,f.$data)),d}var i;h.pa=function(a){a!=d&&!(a instanceof h.t)&&c("templateEngine must inherit from ko.templateEngine"),i=a},h.ua=function(b,c){var d=h.a.J([],b),e=0<b.length?b[0].parentNode:f;a(d,e,function(a){h.wa(c,a)}),a(d,e,function(a){h.r.Sa(a,[c])})},h.na=function(a,e,g,j,k){g=g||{},(g.templateEngine||i)==d&&c("Set a template engine before calling renderTemplate"),k=k||"replaceChildren";if(j){var m=j.nodeType?j:0<j.length?j[0]:f;return new h.i(function(){var c=e&&e instanceof h.K?e:new h.K(h.a.d(e)),d="function"==typeof a?a(c.$data):a,c=b(j,k,d,c,g);"replaceNode"==k&&(j=c,m=j.nodeType?j:0<j.length?j[0]:f)},f,{disposeWhen:function(){return!m||!h.a.ga(m)},disposeWhenNodeIsRemoved:m&&"replaceNode"==k?m.parentNode:m})}return h.r.ka(function(b){h.na(a,e,g,b,"replaceNode")})},h.Ab=function(a,c,e,g,i){function j(a,b){var c=k(a);h.ua(b,c),e.afterRender&&e.afterRender(b,c.$data)}function k(a){return i.createChildContext(h.a.d(a))}return new h.i(function(){var i=h.a.d(c)||[];"undefined"==typeof i.length&&(i=[i]),i=h.a.aa(i,function(a){return e.includeDestroyed||a===d||a===f||!h.a.d(a._destroy)}),h.a.Ka(g,i,function(c){var d="function"==typeof a?a(c):a;return b(f,"ignoreTargetNode",d,k(c),e)},e,j)},f,{disposeWhenNodeIsRemoved:g})},h.c.template={init:function(a,b){var c=h.a.d(b());return"string"!=typeof c&&!c.name&&1==a.nodeType&&((new h.m.I(a)).text(a.innerHTML),h.a.U(a)),{controlsDescendantBindings:e}},update:function(a,b,c,d,g){b=h.a.d(b()),d=e,"string"==typeof b?c=b:(c=b.name,"if"in b&&(d=d&&h.a.d(b["if"])),"ifnot"in b&&(d=d&&!h.a.d(b.ifnot)));var i=f;"object"==typeof b&&"foreach"in b?i=h.Ab(c||a,d&&b.foreach||[],b,a,g):d?(g="object"==typeof b&&"data"in b?g.createChildContext(h.a.d(b.data)):g,i=h.na(c||a,g,b,a)):h.f.ha(a),g=i,(b=h.a.e.get(a,"__ko__templateSubscriptionDomDataKey__"))&&"function"==typeof b.v&&b.v(),h.a.e.set(a,"__ko__templateSubscriptionDomDataKey__",g)}},h.j.D.template=function(a){return a=h.j.Y(a),1==a.length&&a[0].unknown?f:h.j.rb(a,"name")?f:"This template engine does not support anonymous templates nested within its templates"},h.f.C.template=e}(),h.b("ko.setTemplateEngine",h.pa),h.b("ko.renderTemplate",h.na),h.a.N=function(a,b,c){if(c===d)return h.a.N(a,b,1)||h.a.N(a,b,10)||h.a.N(a,b,Number.MAX_VALUE);for(var a=a||[],b=b||[],e=a,g=b,i=[],j=0;j<=g.length;j++)i[j]=[];for(var j=0,k=Math.min(e.length,c);j<=k;j++)i[0][j]=j;j=1;for(k=Math.min(g.length,c);j<=k;j++)i[j][0]=j;for(var k=e.length,m,n=g.length,j=1;j<=k;j++){m=Math.max(1,j-c);for(var p=Math.min(n,j+c);m<=p;m++)i[m][j]=e[j-1]===g[m-1]?i[m-1][j-1]:Math.min(i[m-1][j]===d?Number.MAX_VALUE:i[m-1][j]+1,i[m][j-1]===d?Number.MAX_VALUE:i[m][j-1]+1)}c=a.length,e=b.length,g=[],j=i[e][c];if(j===d)i=f;else{for(;0<c||0<e;){k=i[e][c],n=0<e?i[e-1][c]:j+1,p=0<c?i[e][c-1]:j+1,m=0<e&&0<c?i[e-1][c-1]:j+1;if(n===d||n<k-1)n=j+1;if(p===d||p<k-1)p=j+1;m<k-1&&(m=j+1),n<=p&&n<m?(g.push({status:"added",value:b[e-1]}),e--):(p<n&&p<m?g.push({status:"deleted",value:a[c-1]}):(g.push({status:"retained",value:a[c-1]}),e--),c--)}i=g.reverse()}return i},h.b("ko.utils.compareArrays",h.a.N),function(){function a(a){if(2<a.length){for(var b=a[0],c=a[a.length-1],d=[b];b!==c;){b=b.nextSibling;if(!b)return;d.push(b)}Array.prototype.splice.apply(a,[0,a.length].concat(d))}}function b(b,c,d,e){var g=[],b=h.i(function(){var b=c(d)||[];0<g.length&&(a(g),h.a.Ja(g,b),e&&e(d,b)),g.splice(0,g.length),h.a.J(g,b)},f,{disposeWhenNodeIsRemoved:b,disposeWhen:function(){return 0==g.length||!h.a.ga(g[0])}});return{sb:g,i:b}}h.a.Ka=function(c,i,j,k,n){for(var i=i||[],k=k||{},q=h.a.e.get(c,"setDomNodeChildrenFromArrayMapping_lastMappingResult")===d,s=h.a.e.get(c,"setDomNodeChildrenFromArrayMapping_lastMappingResult")||[],t=h.a.ba(s,function(a){return a.Va}),u=h.a.N(t,i),i=[],v=0,w=[],t=[],x=f,y=0,z=u.length;y<z;y++)switch(u[y].status){case"retained":var A=s[v];i.push(A),0<A.O.length&&(x=A.O[A.O.length-1]),v++;break;case"deleted":s[v].i.v(),a(s[v].O),h.a.n(s[v].O,function(a){w.push({element:a,index:y,value:u[y].value}),x=a}),v++;break;case"added":var A=u[y].value,B=b(c,j,A,n),C=B.sb;i.push({Va:u[y].value,O:C,i:B.i});for(var B=0,D=C.length;B<D;B++){var E=C[B];t.push({element:E,index:y,value:u[y].value}),x==f?h.f.xb(c,E):h.f.mb(c,E,x),x=E}n&&n(A,C)}h.a.n(w,function(a){h.F(a.element)}),j=g;if(!q){if(k.afterAdd)for(y=0;y<t.length;y++)k.afterAdd(t[y].element,t[y].index,t[y].value);if(k.beforeRemove){for(y=0;y<w.length;y++)k.beforeRemove(w[y].element,w[y].index,w[y].value);j=e}}j||h.a.n(w,function(a){h.removeNode(a.element)}),h.a.e.set(c,"setDomNodeChildrenFromArrayMapping_lastMappingResult",i)}}(),h.b("ko.utils.setDomNodeChildrenFromArrayMapping",h.a.Ka),h.p=function(){this.allowTemplateRewriting=g},h.p.prototype=new h.t,h.p.prototype.renderTemplateSource=function(a){return a=a.text(),h.a.ma(a)},h.p.M=new h.p,h.pa(h.p.M),h.b("ko.nativeTemplateEngine",h.p),function(){h.ja=function(){var a=this.qb=function(){if("undefined"==typeof jQuery||!jQuery.tmpl)return 0;try{if(0<=jQuery.tmpl.tag.tmpl.open.toString().indexOf("__"))return 2}catch(a){}return 1}();this.renderTemplateSource=function(b,d,e){e=e||{},2>a&&c(Error("Your version of jQuery.tmpl is too old. Please upgrade to jQuery.tmpl 1.0.0pre or later."));var g=b.data("precompiled");return g||(g=b.text()||"",g=jQuery.template(f,"{{ko_with $item.koBindingContext}}"+g+"{{/ko_with}}"),b.data("precompiled",g)),b=[d.$data],d=jQuery.extend({koBindingContext:d},e.templateOptions),d=jQuery.tmpl(g,b,d),d.appendTo(document.createElement("div")),jQuery.fragments={},d},this.createJavaScriptEvaluatorBlock=function(a){return"{{ko_code ((function() { return "+a+" })()) }}"},this.addTemplate=function(a,b){document.write("<script type='text/html' id='"+a+"'>"+b+"</script>")},0<a&&(jQuery.tmpl.tag.ko_code={open:"__.push($1 || '');"},jQuery.tmpl.tag.ko_with={open:"with($1) {",close:"} "})},h.ja.prototype=new h.t;var a=new h.ja;0<a.qb&&h.pa(a),h.b("ko.jqueryTmplTemplateEngine",h.ja)}()})(window)