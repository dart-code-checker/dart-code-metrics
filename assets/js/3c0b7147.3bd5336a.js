"use strict";(self.webpackChunkdart_code_metrics_website=self.webpackChunkdart_code_metrics_website||[]).push([[6339],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>d});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var s=r.createContext({}),u=function(e){var t=r.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},c=function(e){var t=u(e.components);return r.createElement(s.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},m=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,s=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),m=u(n),d=a,g=m["".concat(s,".").concat(d)]||m[d]||p[d]||o;return n?r.createElement(g,i(i({ref:t},c),{},{components:n})):r.createElement(g,i({ref:t},c))}));function d(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,i=new Array(o);i[0]=m;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:a,i[1]=l;for(var u=2;u<o;u++)i[u]=n[u];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}m.displayName="MDXCreateElement"},1818:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>s,contentTitle:()=>i,default:()=>p,frontMatter:()=>o,metadata:()=>l,toc:()=>u});var r=n(7462),a=(n(7294),n(3905));const o={},i="Component annotation arguments ordering",l={unversionedId:"rules/angular/component-annotation-arguments-ordering",id:"rules/angular/component-annotation-arguments-ordering",title:"Component annotation arguments ordering",description:"Configurable",source:"@site/docs/rules/angular/component-annotation-arguments-ordering.md",sourceDirName:"rules/angular",slug:"/rules/angular/component-annotation-arguments-ordering",permalink:"/docs/rules/angular/component-annotation-arguments-ordering",draft:!1,editUrl:"https://github.com/dart-code-checker/dart-code-metrics/tree/master/website/docs/rules/angular/component-annotation-arguments-ordering.md",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Avoid preserveWhitespace: false",permalink:"/docs/rules/angular/avoid-preserve-whitespace-false"},next:{title:"Prefer using onPush change detection strategy",permalink:"/docs/rules/angular/prefer-on-push-cd-strategy"}},s={},u=[{value:"Rule id",id:"rule-id",level:2},{value:"Severity",id:"severity",level:2},{value:"Description",id:"description",level:2},{value:"Config example",id:"config-example",level:3}],c={toc:u};function p(e){let{components:t,...n}=e;return(0,a.kt)("wrapper",(0,r.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"component-annotation-arguments-ordering"},"Component annotation arguments ordering"),(0,a.kt)("p",null,(0,a.kt)("img",{parentName:"p",src:"https://img.shields.io/badge/-configurable-informational",alt:"Configurable"})),(0,a.kt)("h2",{id:"rule-id"},"Rule id"),(0,a.kt)("p",null,"component-annotation-arguments-ordering"),(0,a.kt)("h2",{id:"severity"},"Severity"),(0,a.kt)("p",null,"Style"),(0,a.kt)("h2",{id:"description"},"Description"),(0,a.kt)("p",null,"Enforces Angular ",(0,a.kt)("inlineCode",{parentName:"p"},"@Component")," annotation arguments ordering."),(0,a.kt)("p",null,"The value for ",(0,a.kt)("inlineCode",{parentName:"p"},"order")," may be an array consisting of the following strings (default order listed):"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"selector"),(0,a.kt)("li",{parentName:"ul"},"templates"),(0,a.kt)("li",{parentName:"ul"},"styles"),(0,a.kt)("li",{parentName:"ul"},"directives"),(0,a.kt)("li",{parentName:"ul"},"pipes"),(0,a.kt)("li",{parentName:"ul"},"providers"),(0,a.kt)("li",{parentName:"ul"},"encapsulation"),(0,a.kt)("li",{parentName:"ul"},"visibility"),(0,a.kt)("li",{parentName:"ul"},"exports"),(0,a.kt)("li",{parentName:"ul"},"change-detection")),(0,a.kt)("h3",{id:"config-example"},"Config example"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-yaml"},"dart_code_metrics:\n  ...\n  rules:\n    ...\n    - component-annotation-arguments-ordering:\n        order:\n          - selector\n          - templates\n          - change-detection\n")))}p.isMDXComponent=!0}}]);