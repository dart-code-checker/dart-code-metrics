"use strict";(self.webpackChunkdart_code_metrics_website=self.webpackChunkdart_code_metrics_website||[]).push([[138],{3905:(e,n,r)=>{r.d(n,{Zo:()=>p,kt:()=>m});var t=r(7294);function o(e,n,r){return n in e?Object.defineProperty(e,n,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[n]=r,e}function i(e,n){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var t=Object.getOwnPropertySymbols(e);n&&(t=t.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),r.push.apply(r,t)}return r}function a(e){for(var n=1;n<arguments.length;n++){var r=null!=arguments[n]?arguments[n]:{};n%2?i(Object(r),!0).forEach((function(n){o(e,n,r[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):i(Object(r)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(r,n))}))}return e}function s(e,n){if(null==e)return{};var r,t,o=function(e,n){if(null==e)return{};var r,t,o={},i=Object.keys(e);for(t=0;t<i.length;t++)r=i[t],n.indexOf(r)>=0||(o[r]=e[r]);return o}(e,n);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(t=0;t<i.length;t++)r=i[t],n.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var l=t.createContext({}),c=function(e){var n=t.useContext(l),r=n;return e&&(r="function"==typeof e?e(n):a(a({},n),e)),r},p=function(e){var n=c(e.components);return t.createElement(l.Provider,{value:n},e.children)},u={inlineCode:"code",wrapper:function(e){var n=e.children;return t.createElement(t.Fragment,{},n)}},d=t.forwardRef((function(e,n){var r=e.components,o=e.mdxType,i=e.originalType,l=e.parentName,p=s(e,["components","mdxType","originalType","parentName"]),d=c(r),m=o,f=d["".concat(l,".").concat(m)]||d[m]||u[m]||i;return r?t.createElement(f,a(a({ref:n},p),{},{components:r})):t.createElement(f,a({ref:n},p))}));function m(e,n){var r=arguments,o=n&&n.mdxType;if("string"==typeof e||o){var i=r.length,a=new Array(i);a[0]=d;var s={};for(var l in n)hasOwnProperty.call(n,l)&&(s[l]=n[l]);s.originalType=e,s.mdxType="string"==typeof e?e:o,a[1]=s;for(var c=2;c<i;c++)a[c]=r[c];return t.createElement.apply(null,a)}return t.createElement.apply(null,r)}d.displayName="MDXCreateElement"},4237:(e,n,r)=>{r.r(n),r.d(n,{assets:()=>l,contentTitle:()=>a,default:()=>u,frontMatter:()=>i,metadata:()=>s,toc:()=>c});var t=r(7462),o=(r(7294),r(3905));const i={},a="Prefer conditional expressions",s={unversionedId:"rules/common/prefer-conditional-expressions",id:"rules/common/prefer-conditional-expressions",title:"Prefer conditional expressions",description:"Has auto-fix",source:"@site/docs/rules/common/prefer-conditional-expressions.md",sourceDirName:"rules/common",slug:"/rules/common/prefer-conditional-expressions",permalink:"/docs/rules/common/prefer-conditional-expressions",draft:!1,editUrl:"https://github.com/dart-code-checker/dart-code-metrics/tree/master/website/docs/rules/common/prefer-conditional-expressions.md",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Prefer commenting analyzer ignores",permalink:"/docs/rules/common/prefer-commenting-analyzer-ignores"},next:{title:"Prefer correct identifier length",permalink:"/docs/rules/common/prefer-correct-identifier-length"}},l={},c=[{value:"Rule id",id:"rule-id",level:2},{value:"Severity",id:"severity",level:2},{value:"Description",id:"description",level:2},{value:"Example",id:"example",level:3}],p={toc:c};function u(e){let{components:n,...r}=e;return(0,o.kt)("wrapper",(0,t.Z)({},p,r,{components:n,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"prefer-conditional-expressions"},"Prefer conditional expressions"),(0,o.kt)("p",null,(0,o.kt)("img",{parentName:"p",src:"https://img.shields.io/badge/-has%20auto--fix-success",alt:"Has auto-fix"})),(0,o.kt)("h2",{id:"rule-id"},"Rule id"),(0,o.kt)("p",null,"prefer-conditional-expressions"),(0,o.kt)("h2",{id:"severity"},"Severity"),(0,o.kt)("p",null,"Style"),(0,o.kt)("h2",{id:"description"},"Description"),(0,o.kt)("p",null,"Recommends to use a conditional expression instead of assigning to the same thing or return statement in each branch of an if statement."),(0,o.kt)("h3",{id:"example"},"Example"),(0,o.kt)("p",null,"Bad:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"  int a = 0;\n\n  // LINT\n  if (a > 0) {\n    a = 1;\n  } else {\n    a = 2;\n  }\n\n  // LINT\n  if (a > 0) a = 1;\n  else a = 2;\n\n  int function() {\n    // LINT\n    if (a == 1) {\n        return 0;\n    } else {\n        return 1;\n    }\n\n    // LINT\n    if (a == 2) return 0;\n    else return 1;\n  }\n")),(0,o.kt)("p",null,"Good:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-dart"},"  int a = 0;\n\n  a = a > 0 ? 1 : 2;\n\n  int function() {\n    return a == 2 ? 0 : 1;\n  }\n")))}u.isMDXComponent=!0}}]);