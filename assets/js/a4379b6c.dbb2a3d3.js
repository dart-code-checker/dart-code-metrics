"use strict";(self.webpackChunkdart_code_metrics_website=self.webpackChunkdart_code_metrics_website||[]).push([[2327],{3905:function(e,n,t){t.d(n,{Zo:function(){return u},kt:function(){return m}});var r=t(7294);function i(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function o(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,r)}return t}function a(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?o(Object(t),!0).forEach((function(n){i(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):o(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function c(e,n){if(null==e)return{};var t,r,i=function(e,n){if(null==e)return{};var t,r,i={},o=Object.keys(e);for(r=0;r<o.length;r++)t=o[r],n.indexOf(t)>=0||(i[t]=e[t]);return i}(e,n);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)t=o[r],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(i[t]=e[t])}return i}var l=r.createContext({}),d=function(e){var n=r.useContext(l),t=n;return e&&(t="function"==typeof e?e(n):a(a({},n),e)),t},u=function(e){var n=d(e.components);return r.createElement(l.Provider,{value:n},e.children)},s={inlineCode:"code",wrapper:function(e){var n=e.children;return r.createElement(r.Fragment,{},n)}},p=r.forwardRef((function(e,n){var t=e.components,i=e.mdxType,o=e.originalType,l=e.parentName,u=c(e,["components","mdxType","originalType","parentName"]),p=d(t),m=i,y=p["".concat(l,".").concat(m)]||p[m]||s[m]||o;return t?r.createElement(y,a(a({ref:n},u),{},{components:t})):r.createElement(y,a({ref:n},u))}));function m(e,n){var t=arguments,i=n&&n.mdxType;if("string"==typeof e||i){var o=t.length,a=new Array(o);a[0]=p;var c={};for(var l in n)hasOwnProperty.call(n,l)&&(c[l]=n[l]);c.originalType=e,c.mdxType="string"==typeof e?e:i,a[1]=c;for(var d=2;d<o;d++)a[d]=t[d];return r.createElement.apply(null,a)}return r.createElement.apply(null,t)}p.displayName="MDXCreateElement"},3118:function(e,n,t){t.r(n),t.d(n,{frontMatter:function(){return c},contentTitle:function(){return l},metadata:function(){return d},assets:function(){return u},toc:function(){return s},default:function(){return m}});var r=t(7462),i=t(3366),o=(t(7294),t(3905)),a=["components"],c={},l="Avoid dynamic",d={unversionedId:"rules/common/avoid-dynamic",id:"rules/common/avoid-dynamic",title:"Avoid dynamic",description:"Rule id",source:"@site/docs/rules/common/avoid-dynamic.md",sourceDirName:"rules/common",slug:"/rules/common/avoid-dynamic",permalink:"/docs/rules/common/avoid-dynamic",editUrl:"https://github.com/dart-code-checker/dart-code-metrics/tree/master/website/docs/rules/common/avoid-dynamic.md",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Avoid collection methods with unrelated types",permalink:"/docs/rules/common/avoid-collection-methods-with-unrelated-types"},next:{title:"Avoid global state",permalink:"/docs/rules/common/avoid-global-state"}},u={},s=[{value:"Rule id",id:"rule-id",level:2},{value:"Severity",id:"severity",level:2},{value:"Description",id:"description",level:2},{value:"Example",id:"example",level:3}],p={toc:s};function m(e){var n=e.components,t=(0,i.Z)(e,a);return(0,o.kt)("wrapper",(0,r.Z)({},p,t,{components:n,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"avoid-dynamic"},"Avoid dynamic"),(0,o.kt)("h2",{id:"rule-id"},"Rule id"),(0,o.kt)("p",null,"avoid-dynamic"),(0,o.kt)("h2",{id:"severity"},"Severity"),(0,o.kt)("p",null,"Warning"),(0,o.kt)("h2",{id:"description"},"Description"),(0,o.kt)("p",null,"Warns when ",(0,o.kt)("inlineCode",{parentName:"p"},"dynamic")," type is used as variable type in declaration, return type of a function, etc. Using ",(0,o.kt)("inlineCode",{parentName:"p"},"dynamic")," is considered unsafe since it can easily result in runtime errors."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Note:")," using ",(0,o.kt)("inlineCode",{parentName:"p"},"dynamic")," type for ",(0,o.kt)("inlineCode",{parentName:"p"},"Map<>")," is considered fine since there is no better way to declare type of JSON payload."),(0,o.kt)("h3",{id:"example"},"Example"),(0,o.kt)("p",null,"Bad:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"dynamic x = 10; // LINT\n\n// LINT\nString concat(dynamic a, dynamic b) {\n  return a + b;\n}\n")),(0,o.kt)("p",null,"Good:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"int x = 10;\n\nfinal x = 10;\n\nString concat(String a, String b) {\n  return a + b;\n}\n")))}m.isMDXComponent=!0}}]);