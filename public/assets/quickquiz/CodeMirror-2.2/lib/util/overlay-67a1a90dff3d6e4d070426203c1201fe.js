// Utility function that allows modes to be combined. The mode given
// as the base argument takes care of most of the normal mode
// functionality, but a second (typically simple) mode is used, which
// can override the style of text. Both modes get to parse all of the
// text, but when both assign a non-null style to a piece of code, the
// overlay wins, unless the combine argument was true, in which case
// the styles are combined.
CodeMirror.overlayParser=function(a,b,c){return{startState:function(){return{base:CodeMirror.startState(a),overlay:CodeMirror.startState(b),basePos:0,baseCur:null,overlayPos:0,overlayCur:null}},copyState:function(c){return{base:CodeMirror.copyState(a,c.base),overlay:CodeMirror.copyState(b,c.overlay),basePos:c.basePos,baseCur:null,overlayPos:c.overlayPos,overlayCur:null}},token:function(d,e){return d.start==e.basePos&&(e.baseCur=a.token(d,e.base),e.basePos=d.pos),d.start==e.overlayPos&&(d.pos=d.start,e.overlayCur=b.token(d,e.overlay),e.overlayPos=d.pos),d.pos=Math.min(e.basePos,e.overlayPos),d.eol()&&(e.basePos=e.overlayPos=0),e.overlayCur==null?e.baseCur:e.baseCur!=null&&c?e.baseCur+" "+e.overlayCur:e.overlayCur},indent:function(b,c){return a.indent(b.base,c)},electricChars:a.electricChars}}