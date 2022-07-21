"use strict";(self.webpackChunkdart_code_metrics_website=self.webpackChunkdart_code_metrics_website||[]).push([[825],{3905:(e,t,r)=>{r.d(t,{Zo:()=>m,kt:()=>d});var n=r(7294);function l(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function i(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){l(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function o(e,t){if(null==e)return{};var r,n,l=function(e,t){if(null==e)return{};var r,n,l={},a=Object.keys(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||(l[r]=e[r]);return l}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(l[r]=e[r])}return l}var p=n.createContext({}),s=function(e){var t=n.useContext(p),r=t;return e&&(r="function"==typeof e?e(t):i(i({},t),e)),r},m=function(e){var t=s(e.components);return n.createElement(p.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},c=n.forwardRef((function(e,t){var r=e.components,l=e.mdxType,a=e.originalType,p=e.parentName,m=o(e,["components","mdxType","originalType","parentName"]),c=s(r),d=l,f=c["".concat(p,".").concat(d)]||c[d]||u[d]||a;return r?n.createElement(f,i(i({ref:t},m),{},{components:r})):n.createElement(f,i({ref:t},m))}));function d(e,t){var r=arguments,l=t&&t.mdxType;if("string"==typeof e||l){var a=r.length,i=new Array(a);i[0]=c;var o={};for(var p in t)hasOwnProperty.call(t,p)&&(o[p]=t[p]);o.originalType=e,o.mdxType="string"==typeof e?e:l,i[1]=o;for(var s=2;s<a;s++)i[s]=r[s];return n.createElement.apply(null,i)}return n.createElement.apply(null,r)}c.displayName="MDXCreateElement"},9644:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>p,contentTitle:()=>i,default:()=>u,frontMatter:()=>a,metadata:()=>o,toc:()=>s});var n=r(7462),l=(r(7294),r(3905));const a={},i="Member ordering extended",o={unversionedId:"rules/common/member-ordering-extended",id:"rules/common/member-ordering-extended",title:"Member ordering extended",description:"Configurable",source:"@site/docs/rules/common/member-ordering-extended.md",sourceDirName:"rules/common",slug:"/rules/common/member-ordering-extended",permalink:"/docs/rules/common/member-ordering-extended",draft:!1,editUrl:"https://github.com/dart-code-checker/dart-code-metrics/tree/master/website/docs/rules/common/member-ordering-extended.md",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Format comments",permalink:"/docs/rules/common/format-comment"},next:{title:"Member ordering",permalink:"/docs/rules/common/member-ordering"}},p={},s=[{value:"Rule id",id:"rule-id",level:2},{value:"Severity",id:"severity",level:2},{value:"Description",id:"description",level:2},{value:"Config example",id:"config-example",level:3}],m={toc:s};function u(e){let{components:t,...r}=e;return(0,l.kt)("wrapper",(0,n.Z)({},m,r,{components:t,mdxType:"MDXLayout"}),(0,l.kt)("h1",{id:"member-ordering-extended"},"Member ordering extended"),(0,l.kt)("p",null,(0,l.kt)("img",{parentName:"p",src:"https://img.shields.io/badge/-configurable-informational",alt:"Configurable"})),(0,l.kt)("h2",{id:"rule-id"},"Rule id"),(0,l.kt)("p",null,"member-ordering-extended"),(0,l.kt)("h2",{id:"severity"},"Severity"),(0,l.kt)("p",null,"Style"),(0,l.kt)("h2",{id:"description"},"Description"),(0,l.kt)("p",null,(0,l.kt)("strong",{parentName:"p"},"Note:")," Don't use it with the default member-ordering rule!"),(0,l.kt)("p",null,"Enforces extended member ordering."),(0,l.kt)("p",null,"The value for the ",(0,l.kt)("inlineCode",{parentName:"p"},"order")," entry should match the following pattern:"),(0,l.kt)("p",null,(0,l.kt)("inlineCode",{parentName:"p"},"< (overridden | protected)- >< (private | public)- >< static- >< late- >< (var | final | const)- >< nullable- >< named- >< factory- > (fields | getters | getters-setters | setters | constructors | methods)")),(0,l.kt)("p",null,"where values in the ",(0,l.kt)("inlineCode",{parentName:"p"},"<>")," are optional, values in the ",(0,l.kt)("inlineCode",{parentName:"p"},"()")," are interchangeable and the last part of the pattern which represents a class member type is ",(0,l.kt)("strong",{parentName:"p"},"REQUIRED"),"."),(0,l.kt)("p",null,(0,l.kt)("strong",{parentName:"p"},"Note:")," not all of the pattern parts are applicable for every case, for example, ",(0,l.kt)("inlineCode",{parentName:"p"},"late-constructors")," are not expected, since they are not supported by the language itself."),(0,l.kt)("p",null,"For example, the value for ",(0,l.kt)("inlineCode",{parentName:"p"},"order")," may be an array consisting of the following strings:"),(0,l.kt)("ul",null,(0,l.kt)("li",{parentName:"ul"},"public-late-final-fields"),(0,l.kt)("li",{parentName:"ul"},"private-late-final-fields"),(0,l.kt)("li",{parentName:"ul"},"public-nullable-fields"),(0,l.kt)("li",{parentName:"ul"},"private-nullable-fields"),(0,l.kt)("li",{parentName:"ul"},"named-constructors"),(0,l.kt)("li",{parentName:"ul"},"factory-constructors"),(0,l.kt)("li",{parentName:"ul"},"getters"),(0,l.kt)("li",{parentName:"ul"},"setters"),(0,l.kt)("li",{parentName:"ul"},"public-static-methods"),(0,l.kt)("li",{parentName:"ul"},"private-static-methods"),(0,l.kt)("li",{parentName:"ul"},"protected-methods"),(0,l.kt)("li",{parentName:"ul"},"etc.")),(0,l.kt)("p",null,"You can simply configure the rule to sort only by a type:"),(0,l.kt)("ul",null,(0,l.kt)("li",{parentName:"ul"},"fields"),(0,l.kt)("li",{parentName:"ul"},"methods"),(0,l.kt)("li",{parentName:"ul"},"setters"),(0,l.kt)("li",{parentName:"ul"},"getters (or just ",(0,l.kt)("strong",{parentName:"li"},"getters-setters")," if you don't want to separate them)"),(0,l.kt)("li",{parentName:"ul"},"constructors")),(0,l.kt)("p",null,"The default config is:"),(0,l.kt)("ul",null,(0,l.kt)("li",{parentName:"ul"},"public-fields"),(0,l.kt)("li",{parentName:"ul"},"private-fields"),(0,l.kt)("li",{parentName:"ul"},"public-getters"),(0,l.kt)("li",{parentName:"ul"},"private-getters"),(0,l.kt)("li",{parentName:"ul"},"public-setters"),(0,l.kt)("li",{parentName:"ul"},"private-setters"),(0,l.kt)("li",{parentName:"ul"},"constructors"),(0,l.kt)("li",{parentName:"ul"},"public-methods"),(0,l.kt)("li",{parentName:"ul"},"private-methods")),(0,l.kt)("p",null,"The ",(0,l.kt)("inlineCode",{parentName:"p"},"alphabetize")," option will enforce that members within the same category should be alphabetically sorted by name."),(0,l.kt)("p",null,"The ",(0,l.kt)("inlineCode",{parentName:"p"},"alphabetize-by-type")," option will enforce that members within the same category should be alphabetically sorted by theirs type name."),(0,l.kt)("p",null,"Only one alphabetize option could be applied at the same time."),(0,l.kt)("h3",{id:"config-example"},"Config example"),(0,l.kt)("p",null,"With the default config:"),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-yaml"},"dart_code_metrics:\n  ...\n  rules:\n    ...\n    - member-ordering-extended\n")),(0,l.kt)("p",null,(0,l.kt)("strong",{parentName:"p"},"OR")," with a custom one:"),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-yaml"},"dart_code_metrics:\n  ...\n  rules:\n    ...\n    - member-ordering-extended:\n        alphabetize: true\n        order:\n          - public-fields\n          - private-fields\n          - constructors\n")))}u.isMDXComponent=!0}}]);