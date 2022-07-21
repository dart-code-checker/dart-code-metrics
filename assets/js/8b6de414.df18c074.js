"use strict";(self.webpackChunkdart_code_metrics_website=self.webpackChunkdart_code_metrics_website||[]).push([[5284],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>g});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function s(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?s(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):s(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},s=Object.keys(e);for(r=0;r<s.length;r++)n=s[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var s=Object.getOwnPropertySymbols(e);for(r=0;r<s.length;r++)n=s[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var m=r.createContext({}),o=function(e){var t=r.useContext(m),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},u=function(e){var t=o(e.components);return r.createElement(m.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},p=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,s=e.originalType,m=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),p=o(n),g=a,d=p["".concat(m,".").concat(g)]||p[g]||c[g]||s;return n?r.createElement(d,i(i({ref:t},u),{},{components:n})):r.createElement(d,i({ref:t},u))}));function g(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var s=n.length,i=new Array(s);i[0]=p;var l={};for(var m in t)hasOwnProperty.call(t,m)&&(l[m]=t[m]);l.originalType=e,l.mdxType="string"==typeof e?e:a,i[1]=l;for(var o=2;o<s;o++)i[o]=n[o];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}p.displayName="MDXCreateElement"},5345:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>m,contentTitle:()=>i,default:()=>c,frontMatter:()=>s,metadata:()=>l,toc:()=>o});var r=n(7462),a=(n(7294),n(3905));const s={},i="Provide correct intl args",l={unversionedId:"rules/intl/provide-correct-intl-args",id:"rules/intl/provide-correct-intl-args",title:"Provide correct intl args",description:"Rule id",source:"@site/docs/rules/intl/provide-correct-intl-args.md",sourceDirName:"rules/intl",slug:"/rules/intl/provide-correct-intl-args",permalink:"/docs/rules/intl/provide-correct-intl-args",draft:!1,editUrl:"https://github.com/dart-code-checker/dart-code-metrics/tree/master/website/docs/rules/intl/provide-correct-intl-args.md",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Prefer Intl name",permalink:"/docs/rules/intl/prefer-intl-name"},next:{title:"Avoid preserveWhitespace: false",permalink:"/docs/rules/angular/avoid-preserve-whitespace-false"}},m={},o=[{value:"Rule id",id:"rule-id",level:2},{value:"Severity",id:"severity",level:2},{value:"Description",id:"description",level:2},{value:"Example",id:"example",level:3}],u={toc:o};function c(e){let{components:t,...n}=e;return(0,a.kt)("wrapper",(0,r.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"provide-correct-intl-args"},"Provide correct intl args"),(0,a.kt)("h2",{id:"rule-id"},"Rule id"),(0,a.kt)("p",null,"provide-correct-intl-args"),(0,a.kt)("h2",{id:"severity"},"Severity"),(0,a.kt)("p",null,"Warning"),(0,a.kt)("h2",{id:"description"},"Description"),(0,a.kt)("p",null,"Warns when the ",(0,a.kt)("inlineCode",{parentName:"p"},"Intl.message()")," invocation has incorrect ",(0,a.kt)("inlineCode",{parentName:"p"},"args")," list."),(0,a.kt)("h3",{id:"example"},"Example"),(0,a.kt)("p",null,"Bad:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},"import 'package:intl/intl.dart';    \n\nclass SomeButtonClassI18n {\n  static const int value = 0;\n  static const String name = 'name';\n\n  static String simpleTitleNotExistArgsIssue(String name) {\n    return Intl.message(\n      'title',\n      name: 'SomeButtonClassI18n_simpleTitleNotExistArgsIssue',\n    );\n  }\n  \n  static String simpleTitleArgsMustBeOmittedIssue1() {\n    return Intl.message(\n      'title $name',\n      name: 'SomeButtonClassI18n_simpleTitleArgsMustBeOmittedIssue1',\n      args:  [name]\n    );\n  }  \n  \n  static String simpleTitleArgsMustBeOmittedIssue2() {\n    return Intl.message(\n      'title',\n      name: 'SomeButtonClassI18n_simpleTitleArgsMustBeOmittedIssue2',\n      args:  [name]\n    );\n  }  \n  \n  static String simpleArgsItemMustBeOmittedIssue(int value) {\n    return Intl.message(\n      'title $value',\n      name: 'SomeButtonClassI18n_simpleArgsItemMustBeOmittedIssue',\n      args:  [value, name]\n    );\n  }  \n  \n  static String simpleParameterMustBeOmittedIssue(String name, int value) {\n    return Intl.message(\n      'title $value',\n      name: 'SomeButtonClassI18n_simpleParameterMustBeOmittedIssue',\n      args:  [value, name]\n    );\n  }  \n  \n  static String simpleMustBeSimpleIdentifierIssue1(int value) {\n    return Intl.message(\n      'title ${value+1}',\n      name: 'SomeButtonClassI18n_simpleMustBeSimpleIdentifierIssue1',\n      args:  [value]\n    );\n  }  \n  \n  static String simpleMustBeSimpleIdentifierIssue2(int value) {\n    return Intl.message(\n      'title $value',\n      name: 'SomeButtonClassI18n_simpleMustBeSimpleIdentifierIssue2',\n      args:  [value+1]\n    );\n  }  \n  \n  static String simpleParameterMustBeInArgsIssue(int value, String name) {\n    return Intl.message(\n      'title $value, name: $name',\n      name: 'SomeButtonClassI18n_simpleParameterMustBeInArgsIssue',\n      args:  [value]\n    );\n  }\n  \n  static String simpleArgsMustBeInParameterIssue(int value) {\n    return Intl.message(\n      'title $value, name: $name',\n      name: 'SomeButtonClassI18n_simpleArgsMustBeInParameterIssue',\n      args:  [value, name]\n    );\n  }\n  \n  static String simpleInterpolationMustBeInArgsIssue(int value, String name) {\n    return Intl.message(\n      'title $value, name: $name',\n      name: 'SomeButtonClassI18n_simpleInterpolationMustBeInArgsIssue',\n      args:  [value]\n    );\n  }\n  \n  static String simpleInterpolationMustBeInParameterIssue(int value) {\n    return Intl.message(\n      'title $value, name: $name',\n      name: 'SomeButtonClassI18n_simpleInterpolationMustBeInParameterIssue',\n      args:  [value, name]\n    );\n  } \n}\n")),(0,a.kt)("p",null,"Good:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-dart"},"import 'package:intl/intl.dart';    \n\nclass SomeButtonClassI18n {\n\n  static String simpleTitle() {\n    return Intl.message(\n      'title',\n      name: 'SomeButtonClassI18n_simpleTitle',\n    );\n  }\n\n  static String titleWithParameter(String name) {\n    return Intl.message(\n      'title $name',\n      name: 'SomeButtonClassI18n_titleWithParameter',\n      args: [name],\n    );\n  }\n\n  static String titleWithManyParameter(String name, int value) {\n    return Intl.message(\n      'title $name, value: $value',\n      name: 'SomeButtonClassI18n_titleWithManyParameter',\n      args: [name, value],\n    );\n  }\n\n  static String titleWithOptionalParameter({String name}) {\n    return Intl.message(\n      'title $name',\n      name: 'SomeButtonClassI18n_titleWithOptionalParameter',\n      args: [name],\n    );\n  }\n\n  static String titleWithManyOptionalParameter({String name, int value}) {\n    return Intl.message(\n      'title $name, value: $value',\n      name: 'SomeButtonClassI18n_titleWithOptionalParameter',\n      args: [name, value],\n    );\n  }\n\n  static String titleWithPositionParameter([String name]) {\n    return Intl.message(\n      'title $name',\n      name: 'SomeButtonClassI18n_titleWithPositionParameter',\n      args: [name],\n    );\n  }\n\n  static String titleWithManyPositionParameter([String name, int value]) {\n    return Intl.message(\n      'title $name, value: $value',\n      name: 'SomeButtonClassI18n_titleWithManyPositionParameter',\n      args: [name, value],\n    );\n  }\n}\n")))}c.isMDXComponent=!0}}]);