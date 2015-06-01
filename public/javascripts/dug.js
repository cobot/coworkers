/*

 @name		 Dug.js — A JSONP to HTML Script
 @author     Rogie King <rogiek@gmail.com>
 @version	 1.0
 @license    WTFPL — http://en.wikipedia.org/wiki/WTFPL
 @donate	 My paypal email is rogiek@gmail.com if you want to buy me a brew.

*/

(function(global,factory){if(typeof exports==="object"&&exports){factory(exports)}else if(typeof define==="function"&&define.amd){define(["exports"],factory)}else{factory(global.Mustache={})}})(this,function(mustache){var Object_toString=Object.prototype.toString;var isArray=Array.isArray||function(object){return Object_toString.call(object)==="[object Array]"};function isFunction(object){return typeof object==="function"}function escapeRegExp(string){return string.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g,"\\$&")}var RegExp_test=RegExp.prototype.test;function testRegExp(re,string){return RegExp_test.call(re,string)}var nonSpaceRe=/\S/;function isWhitespace(string){return!testRegExp(nonSpaceRe,string)}var entityMap={"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;","/":"&#x2F;"};function escapeHtml(string){return String(string).replace(/[&<>"'\/]/g,function(s){return entityMap[s]})}var whiteRe=/\s*/;var spaceRe=/\s+/;var equalsRe=/\s*=/;var curlyRe=/\s*\}/;var tagRe=/#|\^|\/|>|\{|&|=|!/;function parseTemplate(template,tags){if(!template)return[];var sections=[];var tokens=[];var spaces=[];var hasTag=false;var nonSpace=false;function stripSpace(){if(hasTag&&!nonSpace){while(spaces.length)delete tokens[spaces.pop()]}else{spaces=[]}hasTag=false;nonSpace=false}var openingTagRe,closingTagRe,closingCurlyRe;function compileTags(tags){if(typeof tags==="string")tags=tags.split(spaceRe,2);if(!isArray(tags)||tags.length!==2)throw new Error("Invalid tags: "+tags);openingTagRe=new RegExp(escapeRegExp(tags[0])+"\\s*");closingTagRe=new RegExp("\\s*"+escapeRegExp(tags[1]));closingCurlyRe=new RegExp("\\s*"+escapeRegExp("}"+tags[1]))}compileTags(tags||mustache.tags);var scanner=new Scanner(template);var start,type,value,chr,token,openSection;while(!scanner.eos()){start=scanner.pos;value=scanner.scanUntil(openingTagRe);if(value){for(var i=0,valueLength=value.length;i<valueLength;++i){chr=value.charAt(i);if(isWhitespace(chr)){spaces.push(tokens.length)}else{nonSpace=true}tokens.push(["text",chr,start,start+1]);start+=1;if(chr==="\n")stripSpace()}}if(!scanner.scan(openingTagRe))break;hasTag=true;type=scanner.scan(tagRe)||"name";scanner.scan(whiteRe);if(type==="="){value=scanner.scanUntil(equalsRe);scanner.scan(equalsRe);scanner.scanUntil(closingTagRe)}else if(type==="{"){value=scanner.scanUntil(closingCurlyRe);scanner.scan(curlyRe);scanner.scanUntil(closingTagRe);type="&"}else{value=scanner.scanUntil(closingTagRe)}if(!scanner.scan(closingTagRe))throw new Error("Unclosed tag at "+scanner.pos);token=[type,value,start,scanner.pos];tokens.push(token);if(type==="#"||type==="^"){sections.push(token)}else if(type==="/"){openSection=sections.pop();if(!openSection)throw new Error('Unopened section "'+value+'" at '+start);if(openSection[1]!==value)throw new Error('Unclosed section "'+openSection[1]+'" at '+start)}else if(type==="name"||type==="{"||type==="&"){nonSpace=true}else if(type==="="){compileTags(value)}}openSection=sections.pop();if(openSection)throw new Error('Unclosed section "'+openSection[1]+'" at '+scanner.pos);return nestTokens(squashTokens(tokens))}function squashTokens(tokens){var squashedTokens=[];var token,lastToken;for(var i=0,numTokens=tokens.length;i<numTokens;++i){token=tokens[i];if(token){if(token[0]==="text"&&lastToken&&lastToken[0]==="text"){lastToken[1]+=token[1];lastToken[3]=token[3]}else{squashedTokens.push(token);lastToken=token}}}return squashedTokens}function nestTokens(tokens){var nestedTokens=[];var collector=nestedTokens;var sections=[];var token,section;for(var i=0,numTokens=tokens.length;i<numTokens;++i){token=tokens[i];switch(token[0]){case"#":case"^":collector.push(token);sections.push(token);collector=token[4]=[];break;case"/":section=sections.pop();section[5]=token[2];collector=sections.length>0?sections[sections.length-1][4]:nestedTokens;break;default:collector.push(token)}}return nestedTokens}function Scanner(string){this.string=string;this.tail=string;this.pos=0}Scanner.prototype.eos=function(){return this.tail===""};Scanner.prototype.scan=function(re){var match=this.tail.match(re);if(!match||match.index!==0)return"";var string=match[0];this.tail=this.tail.substring(string.length);this.pos+=string.length;return string};Scanner.prototype.scanUntil=function(re){var index=this.tail.search(re),match;switch(index){case-1:match=this.tail;this.tail="";break;case 0:match="";break;default:match=this.tail.substring(0,index);this.tail=this.tail.substring(index)}this.pos+=match.length;return match};function Context(view,parentContext){this.view=view;this.cache={".":this.view};this.parent=parentContext}Context.prototype.push=function(view){return new Context(view,this)};Context.prototype.lookup=function(name){var cache=this.cache;var value;if(name in cache){value=cache[name]}else{var context=this,names,index,lookupHit=false;while(context){if(name.indexOf(".")>0){value=context.view;names=name.split(".");index=0;while(value!=null&&index<names.length){if(index===names.length-1&&value!=null)lookupHit=typeof value==="object"&&value.hasOwnProperty(names[index]);value=value[names[index++]]}}else if(context.view!=null&&typeof context.view==="object"){value=context.view[name];lookupHit=context.view.hasOwnProperty(name)}if(lookupHit)break;context=context.parent}cache[name]=value}if(isFunction(value))value=value.call(this.view);return value};function Writer(){this.cache={}}Writer.prototype.clearCache=function(){this.cache={}};Writer.prototype.parse=function(template,tags){var cache=this.cache;var tokens=cache[template];if(tokens==null)tokens=cache[template]=parseTemplate(template,tags);return tokens};Writer.prototype.render=function(template,view,partials){var tokens=this.parse(template);var context=view instanceof Context?view:new Context(view);return this.renderTokens(tokens,context,partials,template)};Writer.prototype.renderTokens=function(tokens,context,partials,originalTemplate){var buffer="";var token,symbol,value;for(var i=0,numTokens=tokens.length;i<numTokens;++i){value=undefined;token=tokens[i];symbol=token[0];if(symbol==="#")value=this._renderSection(token,context,partials,originalTemplate);else if(symbol==="^")value=this._renderInverted(token,context,partials,originalTemplate);else if(symbol===">")value=this._renderPartial(token,context,partials,originalTemplate);else if(symbol==="&")value=this._unescapedValue(token,context);else if(symbol==="name")value=this._escapedValue(token,context);else if(symbol==="text")value=this._rawValue(token);if(value!==undefined)buffer+=value}return buffer};Writer.prototype._renderSection=function(token,context,partials,originalTemplate){var self=this;var buffer="";var value=context.lookup(token[1]);function subRender(template){return self.render(template,context,partials)}if(!value)return;if(isArray(value)){for(var j=0,valueLength=value.length;j<valueLength;++j){buffer+=this.renderTokens(token[4],context.push(value[j]),partials,originalTemplate)}}else if(typeof value==="object"||typeof value==="string"||typeof value==="number"){buffer+=this.renderTokens(token[4],context.push(value),partials,originalTemplate)}else if(isFunction(value)){if(typeof originalTemplate!=="string")throw new Error("Cannot use higher-order sections without the original template");value=value.call(context.view,originalTemplate.slice(token[3],token[5]),subRender);if(value!=null)buffer+=value}else{buffer+=this.renderTokens(token[4],context,partials,originalTemplate)}return buffer};Writer.prototype._renderInverted=function(token,context,partials,originalTemplate){var value=context.lookup(token[1]);if(!value||isArray(value)&&value.length===0)return this.renderTokens(token[4],context,partials,originalTemplate)};Writer.prototype._renderPartial=function(token,context,partials){if(!partials)return;var value=isFunction(partials)?partials(token[1]):partials[token[1]];if(value!=null)return this.renderTokens(this.parse(value),context,partials,value)};Writer.prototype._unescapedValue=function(token,context){var value=context.lookup(token[1]);if(value!=null)return value};Writer.prototype._escapedValue=function(token,context){var value=context.lookup(token[1]);if(value!=null)return mustache.escape(value)};Writer.prototype._rawValue=function(token){return token[1]};mustache.name="mustache.js";mustache.version="2.0.0";mustache.tags=["{{","}}"];var defaultWriter=new Writer;mustache.clearCache=function(){return defaultWriter.clearCache()};mustache.parse=function(template,tags){return defaultWriter.parse(template,tags)};mustache.render=function(template,view,partials){return defaultWriter.render(template,view,partials)};mustache.to_html=function(template,view,partials,send){var result=mustache.render(template,view,partials);if(isFunction(send)){send(result)}else{return result}};mustache.escape=escapeHtml;mustache.Scanner=Scanner;mustache.Context=Context;mustache.Writer=Writer});

var dug = function( opts ){

	if(this.constructor != dug ){
		dug.instance = new dug( opts ).show();
		return dug.instance;
	}

	var options = {
			target: null,
			endpoint: '',
			templateDelimiters: ['{{','}}'],
			callbackParam: 'callback',
			cacheExpire: 1000 * 60 * 2,
			beforeRender: function(){},
			afterRender: function(){},
			success: function(){},
			error: function(){},
			template: 'You need a template, silly :P'
		},
		getTemplate = function( template ){
			var template = template || options.template,
				tpl;
			if( template.match(/^(#|\.)\w/) ){
				if( 'querySelectorAll' in document ){
					tpl = document.querySelectorAll( template );
					if( tpl.length > 0 ){
						tpl = tpl[0];
					}
				} else {
					tpl = document.getElementById( template.replace(/^#/,'') );
				}
				if( tpl && 'tagName' in tpl ){
					template = tpl.innerHTML;
				}
			}
			return template;
		},
		ext = function(o1,o2){
			for(var key in o2){
				if( key in o1 ){
					if( o1[key] && o1[key].constructor == Object ){
						ext(o1[key],o2[key]);
					}else{
						o1[key] = o2[key];
					}
				}
			}
		},
		limit = function(array,lim){
			if( typeof array.slice == 'function'){
				return array.slice(0,lim);
			}else{
				return array;
			}
		},
		ago = function(time){
			var date = new Date((time || "")),
				diff = (((new Date()).getTime() - date.getTime()) / 1000),
				day_diff = Math.floor(diff / 86400);
			if ( isNaN(day_diff) || day_diff < 0)
				return;
			return day_diff == 0 && (
					diff < 60 && "just now" ||
					diff < 120 && "1 minute ago" ||
					diff < 3600 && Math.floor(diff/60) + " minutes ago" ||
					diff < 7200 && "1 hour ago" ||
					diff < 86400 && Math.floor(diff/3600) + " hours ago") ||
				  day_diff == 1 && "Yesterday" ||
				  day_diff < 7 && day_diff + " days ago" ||
				  day_diff < 31 && Math.ceil(day_diff/7) + " week" + (Math.ceil(day_diff/7) > 1? 's' : '') + " ago" ||
				  day_diff < 365 && Math.ceil(day_diff/30) + " months ago" ||
				  day_diff >= 365 && Math.ceil(day_diff/365) + " year" + (Math.ceil(day_diff/365)>1?"s":"") + " ago";
		},
		cache = function( key, json ){
			if( (typeof localStorage !== undefined) && (typeof JSON !== undefined) ){
				var now = new Date().getTime(),
					cachedData = null;
				if( json == undefined ){
					try{ cachedData = JSON.parse(unescape(localStorage.getItem(key))); }catch(e){}
					if( cachedData ){
						if( (now - cachedData.time) < options.cacheExpire ){
							cachedData = cachedData.data;
						} else {
							localStorage.removeItem(key);
							cachedData = null;
						}
					}else{
						cachedData = null;
					}
					return cachedData;
				}else{
					try{
						localStorage.setItem(key, escape(JSON.stringify({time:now,data:json})));
					}catch(e){
						console.log(e);
					}
				}
			}else{
				return null;
			}
		},
		get = function(){
			dug.requests = (dug.requests == undefined? 1:dug.requests+1);
			var get = document.createElement('script');
			var	callkey = 'callback' + dug.requests,
				kids = document.body.children,
				script = document.scripts[document.scripts.length-1],
				url = render(options.endpoint),
				scriptInBody = script.parentNode.nodeName != 'head';
				dug[callkey] = function(json,cached){
					json = json.results? json.results : json;
					if( cached !== true ){
						cache(url,json);
					}
					var vessel = document.createElement('div');
					options.beforeRender.call(this,json);
					vessel.innerHTML = render( getTemplate() ,json, options.templateDelimiters);
					if( options.target == null ){
						script.parentNode.insertBefore(vessel,script);
						options.target = vessel;
					}else{
						if( options.target.nodeName ){
							options.target.innerHTML = vessel.innerHTML;
						}else if (typeof options.target == 'string' ){
							document.getElementById(options.target).innerHTML = vessel.innerHTML;
						}
					}
					options.afterRender.call(this,options.target);
					options.success.call(this,json);
				}
				get.onerror = options.error;
			if( cachedData = cache(url) ){
				dug[callkey](cachedData,true);
			}else{
				get.src = url + (url.indexOf('?') > -1? '&': '?') + options.callbackParam + '=dug.' + callkey;
				document.getElementsByTagName('head')[0].appendChild(get);
			}
		},
		init = function( opts ){
			if( opts && opts != undefined ){
				if (opts.constructor == Object) {
					ext(options,opts);
				}
			}
		};

	//private methods
	function render( tpl, data, delims ){
		tpl = unescape(tpl);


	  return Mustache.render(tpl, data);
	}

	//public methods (getter/setters)
	for( var o in options ){
		(function(methodName){
			this[methodName] = function( arg ){
			if( arguments.length ){
				options[methodName] = arg;
			} else {
				return options[methodName];
			}
		}
		}).call(this,o);
	}

	this.show = function( opts ){
		init( opts );
		get();
		return this;
	}

	//utility methods
	dug.render = render;
	dug.extend = ext;
	dug.cache  = cache;
	dug.ago    = ago;
	dug.limit  = limit;

	init( opts );
}
//so that we can read vars
dug._script = document.scripts[document.scripts.length-1];
