(function(b){function y(a,c,f){var d=this;return this.on("click.pjax",a,function(a){var e=b.extend({},j(c,f));e.container||(e.container=b(this).attr("data-pjax")||d);n(a,e)})}function n(a,c,f){f=j(c,f);c=a.currentTarget;if("A"!==c.tagName.toUpperCase())throw"$.fn.pjax or $.pjax.click requires an anchor element";if(!(1<a.which||a.metaKey||a.ctrlKey||a.shiftKey||a.altKey))if(!(location.protocol!==c.protocol||location.host!==c.host)&&!(c.hash&&c.href.replace(c.hash,"")===location.href.replace(location.hash,
""))&&c.href!==location.href+"#")c={url:c.href,container:b(c).attr("data-pjax"),target:c,fragment:null},e(b.extend({},c,f)),a.preventDefault()}function z(a,c,f){f=j(c,f);c=a.currentTarget;if("FORM"!==c.tagName.toUpperCase())throw"$.pjax.submit requires a form element";c={type:c.method,url:c.action,data:b(c).serializeArray(),container:b(c).attr("data-pjax"),target:c,fragment:null,timeout:0};e(b.extend({},c,f));a.preventDefault()}function e(a){function c(a,c){var d=b.Event(a,{relatedTarget:f});i.trigger(d,
c);return!d.isDefaultPrevented()}a=b.extend(!0,{},b.ajaxSettings,e.defaults,a);b.isFunction(a.url)&&(a.url=a.url());var f=a.target,d=q(a.url).hash,i=a.context=s(a.container);a.data||(a.data={});a.data._pjax=i.selector;var k;a.beforeSend=function(b,d){"GET"!==d.type&&(d.timeout=0);0<d.timeout&&(k=setTimeout(function(){c("pjax:timeout",[b,a])&&b.abort("timeout")},d.timeout),d.timeout=0);b.setRequestHeader("X-PJAX","true");b.setRequestHeader("X-PJAX-Container",i.selector);if(!c("pjax:beforeSend",[b,
d]))return!1;a.requestUrl=q(d.url).href};a.complete=function(b,d){k&&clearTimeout(k);c("pjax:complete",[b,d,a]);c("pjax:end",[b,a])};a.error=function(b,d,e){var f=t("",b,a),b=c("pjax:error",[b,d,e,a]);"abort"!==d&&b&&r(f.url)};a.success=function(f,g,k){var h=t(f,k,a);if(h.contents){e.state={id:a.id||(new Date).getTime(),url:h.url,title:h.title,container:i.selector,fragment:a.fragment,timeout:a.timeout};(a.push||a.replace)&&window.history.replaceState(e.state,h.title,h.url);h.title&&(document.title=
h.title);i.html(h.contents);"number"===typeof a.scrollTo&&b(window).scrollTop(a.scrollTo);(a.replace||a.push)&&window._gaq&&_gaq.push(["_trackPageview"]);if(""!==d){var j=q(h.url);j.hash=d;e.state.url=j.href;window.history.replaceState(e.state,h.title,j.href);h=b(j.hash);h.length&&b(window).scrollTop(h.offset().top)}c("pjax:success",[f,g,k,a])}else r(h.url)};e.state||(e.state={id:(new Date).getTime(),url:window.location.href,title:document.title,container:i.selector,fragment:a.fragment,timeout:a.timeout},
window.history.replaceState(e.state,document.title));var g=e.xhr;g&&4>g.readyState&&(g.onreadystatechange=b.noop,g.abort());e.options=a;g=e.xhr=b.ajax(a);if(0<g.readyState){if(a.push&&!a.replace){var j=e.state.id,n=i.clone().contents();l[j]=n;for(m.push(j);p.length;)delete l[p.shift()];for(;m.length>e.defaults.maxCacheLength;)delete l[m.shift()];window.history.pushState(null,"",u(a.requestUrl))}c("pjax:start",[g,a]);c("pjax:send",[g,a])}return e.xhr}function A(a,c){return e(b.extend({url:window.location.href,
push:!1,replace:!0,scrollTo:!1},j(a,c)))}function r(a){window.history.replaceState(null,"","#");window.location.replace(a)}function v(a){if((a=a.state)&&a.container){var c=b(a.container);if(c.length){var f=l[a.id];if(e.state){var d=e.state.id<a.id?"forward":"back",i=d,k=e.state.id,g=c.clone().contents();l[k]=g;"forward"===i?(i=m,g=p):(i=p,g=m);i.push(k);(k=g.pop())&&delete l[k]}d=b.Event("pjax:popstate",{state:a,direction:d});c.trigger(d);d={id:a.id,url:a.url,container:c,push:!1,fragment:a.fragment,
timeout:a.timeout,scrollTo:!1};f?(c.trigger("pjax:start",[null,d]),a.title&&(document.title=a.title),c.html(f),e.state=a,c.trigger("pjax:end",[null,d])):e(d);c[0].offsetHeight}else r(location.href)}}function B(a){var c=b.isFunction(a.url)?a.url():a.url,f=a.type?a.type.toUpperCase():"GET",d=b("<form>",{method:"GET"===f?"GET":"POST",action:c,style:"display:none"});"GET"!==f&&"POST"!==f&&d.append(b("<input>",{type:"hidden",name:"_method",value:f.toLowerCase()}));a=a.data;if("string"===typeof a)b.each(a.split("&"),
function(a,c){var f=c.split("=");d.append(b("<input>",{type:"hidden",name:f[0],value:f[1]}))});else if("object"===typeof a)for(key in a)d.append(b("<input>",{type:"hidden",name:key,value:a[key]}));b(document.body).append(d);d.submit()}function u(a){return a.replace(/\?_pjax=[^&]+&?/,"?").replace(/_pjax=[^&]+&?/,"").replace(/[\?&]$/,"")}function q(a){var b=document.createElement("a");b.href=a;return b}function j(a,c){a&&c?c.container=a:c=b.isPlainObject(a)?a:{container:a};c.container&&(c.container=
s(c.container));return c}function s(a){a=b(a);if(a.length){if(""!==a.selector&&a.context===document)return a;if(a.attr("id"))return b("#"+a.attr("id"));throw"cant get selector for pjax container!";}throw"no pjax container for "+a.selector;}function t(a,c,f){var d={};d.url=u(c.getResponseHeader("X-PJAX-URL")||f.requestUrl);if(/<html/i.test(a))var c=b(a.match(/<head[^>]*>([\s\S.]*)<\/head>/i)[0]),e=b(a.match(/<body[^>]*>([\s\S.]*)<\/body>/i)[0]);else c=e=b(a);if(0===e.length)return d;d.title=c.filter("title").add(c.find("title")).last().text();
f.fragment?(a="body"===f.fragment?e:e.filter(f.fragment).add(e.find(f.fragment)).first(),a.length&&(d.contents=a.contents(),d.title||(d.title=a.attr("title")||a.data("title")))):/<html/i.test(a)||(d.contents=e);d.contents&&(d.contents=d.contents.not("title"),d.contents.find("title").remove());d.title&&(d.title=b.trim(d.title));return d}function w(){b.fn.pjax=y;b.pjax=e;b.pjax.enable=b.noop;b.pjax.disable=x;b.pjax.click=n;b.pjax.submit=z;b.pjax.reload=A;b.pjax.defaults={timeout:650,push:!0,replace:!1,
type:"GET",dataType:"html",scrollTo:0,maxCacheLength:20};b(window).bind("popstate.pjax",v)}function x(){b.fn.pjax=function(){return this};b.pjax=B;b.pjax.enable=w;b.pjax.disable=b.noop;b.pjax.click=b.noop;b.pjax.submit=b.noop;b.pjax.reload=function(){window.location.reload()};b(window).unbind("popstate.pjax",v)}var l={},p=[],m=[];0>b.inArray("state",b.event.props)&&b.event.props.push("state");b.support.pjax=window.history&&window.history.pushState&&window.history.replaceState&&!navigator.userAgent.match(/((iPod|iPhone|iPad).+\bOS\s+[1-4]|WebApps\/.+CFNetwork)/);
b.support.pjax?w():x()})(jQuery);