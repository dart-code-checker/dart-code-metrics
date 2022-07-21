"use strict";(self.webpackChunkdart_code_metrics_website=self.webpackChunkdart_code_metrics_website||[]).push([[5679],{3905:(e,t,r)=>{r.d(t,{Zo:()=>c,kt:()=>u});var n=r(7294);function o(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function i(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){o(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,n,o=function(e,t){if(null==e)return{};var r,n,o={},a=Object.keys(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var d=n.createContext({}),s=function(e){var t=n.useContext(d),r=t;return e&&(r="function"==typeof e?e(t):i(i({},t),e)),r},c=function(e){var t=s(e.components);return n.createElement(d.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},m=n.forwardRef((function(e,t){var r=e.components,o=e.mdxType,a=e.originalType,d=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),m=s(r),u=o,f=m["".concat(d,".").concat(u)]||m[u]||p[u]||a;return r?n.createElement(f,i(i({ref:t},c),{},{components:r})):n.createElement(f,i({ref:t},c))}));function u(e,t){var r=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=r.length,i=new Array(a);i[0]=m;var l={};for(var d in t)hasOwnProperty.call(t,d)&&(l[d]=t[d]);l.originalType=e,l.mdxType="string"==typeof e?e:o,i[1]=l;for(var s=2;s<a;s++)i[s]=r[s];return n.createElement.apply(null,i)}return n.createElement.apply(null,r)}m.displayName="MDXCreateElement"},87:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>d,contentTitle:()=>i,default:()=>p,frontMatter:()=>a,metadata:()=>l,toc:()=>s});var n=r(7462),o=(r(7294),r(3905));const a={},i="Avoid banned imports",l={unversionedId:"rules/common/avoid-banned-imports",id:"rules/common/avoid-banned-imports",title:"Avoid banned imports",description:"Rule id",source:"@site/docs/rules/common/avoid-banned-imports.md",sourceDirName:"rules/common",slug:"/rules/common/avoid-banned-imports",permalink:"/docs/rules/common/avoid-banned-imports",draft:!1,editUrl:"https://github.com/dart-code-checker/dart-code-metrics/tree/master/website/docs/rules/common/avoid-banned-imports.md",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Overview",permalink:"/docs/rules/overview"},next:{title:"Avoid collection methods with unrelated types",permalink:"/docs/rules/common/avoid-collection-methods-with-unrelated-types"}},d={},s=[{value:"Rule id",id:"rule-id",level:2},{value:"Severity",id:"severity",level:2},{value:"Description",id:"description",level:2},{value:"Example",id:"example",level:3},{value:"Config example",id:"config-example",level:3}],c={toc:s};function p(e){let{components:t,...r}=e;return(0,o.kt)("wrapper",(0,n.Z)({},c,r,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"avoid-banned-imports"},"Avoid banned imports"),(0,o.kt)("h2",{id:"rule-id"},"Rule id"),(0,o.kt)("p",null,"avoid-banned-imports"),(0,o.kt)("h2",{id:"severity"},"Severity"),(0,o.kt)("p",null,"Style"),(0,o.kt)("h2",{id:"description"},"Description"),(0,o.kt)("p",null,"Configure some imports that you want to ban."),(0,o.kt)("h3",{id:"example"},"Example"),(0,o.kt)("p",null,"With the configuration in the example below, here are some bad/good examples."),(0,o.kt)("p",null,"Bad:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},'import "package:flutter/material.dart";\nimport "package:flutter_bloc/flutter_bloc.dart";\n')),(0,o.kt)("p",null,"Good:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"// No restricted imports in listed folders.\n")),(0,o.kt)("h3",{id:"config-example"},"Config example"),(0,o.kt)("p",null,"The ",(0,o.kt)("inlineCode",{parentName:"p"},"paths")," and ",(0,o.kt)("inlineCode",{parentName:"p"},"deny")," both support regular expressions."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-yaml"},'dart_code_metrics:\n  ...\n  rules:\n    ...\n    - avoid_restricted_imports:\n        entries:\n        - paths: ["some/folder/.*\\.dart", "another/folder/.*\\.dart"]\n          deny: ["package:flutter/material.dart"]\n          message: "Do not import Flutter Material Design library, we should not depend on it!"\n        - paths: ["core/.*\\.dart"]\n          deny: ["package:flutter_bloc/flutter_bloc.dart"]\n          message: \'State management should be not used inside "core" folder.\'\n')))}p.isMDXComponent=!0}}]);