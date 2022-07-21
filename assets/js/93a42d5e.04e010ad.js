"use strict";(self.webpackChunkdart_code_metrics_website=self.webpackChunkdart_code_metrics_website||[]).push([[1965],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>g});var r=n(7294);function i(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){i(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function o(e,t){if(null==e)return{};var n,r,i=function(e,t){if(null==e)return{};var n,r,i={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(i[n]=e[n]);return i}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(i[n]=e[n])}return i}var d=r.createContext({}),s=function(e){var t=r.useContext(d),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(d.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},p=r.forwardRef((function(e,t){var n=e.components,i=e.mdxType,a=e.originalType,d=e.parentName,u=o(e,["components","mdxType","originalType","parentName"]),p=s(n),g=i,m=p["".concat(d,".").concat(g)]||p[g]||c[g]||a;return n?r.createElement(m,l(l({ref:t},u),{},{components:n})):r.createElement(m,l({ref:t},u))}));function g(e,t){var n=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var a=n.length,l=new Array(a);l[0]=p;var o={};for(var d in t)hasOwnProperty.call(t,d)&&(o[d]=t[d]);o.originalType=e,o.mdxType="string"==typeof e?e:i,l[1]=o;for(var s=2;s<a;s++)l[s]=n[s];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}p.displayName="MDXCreateElement"},1257:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>d,contentTitle:()=>l,default:()=>c,frontMatter:()=>a,metadata:()=>o,toc:()=>s});var r=n(7462),i=(n(7294),n(3905));const a={},l="Avoid returning widgets",o={unversionedId:"rules/flutter/avoid-returning-widgets",id:"rules/flutter/avoid-returning-widgets",title:"Avoid returning widgets",description:"Configurable",source:"@site/docs/rules/flutter/avoid-returning-widgets.md",sourceDirName:"rules/flutter",slug:"/rules/flutter/avoid-returning-widgets",permalink:"/docs/rules/flutter/avoid-returning-widgets",draft:!1,editUrl:"https://github.com/dart-code-checker/dart-code-metrics/tree/master/website/docs/rules/flutter/avoid-returning-widgets.md",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Avoid using Border.all constructor",permalink:"/docs/rules/flutter/avoid-border-all"},next:{title:"Avoid shrink wrap in lists",permalink:"/docs/rules/flutter/avoid-shrink-wrap-in-lists"}},d={},s=[{value:"Rule id",id:"rule-id",level:2},{value:"Severity",id:"severity",level:2},{value:"Description",id:"description",level:2},{value:"Config example",id:"config-example",level:3},{value:"Example",id:"example",level:3}],u={toc:s};function c(e){let{components:t,...n}=e;return(0,i.kt)("wrapper",(0,r.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"avoid-returning-widgets"},"Avoid returning widgets"),(0,i.kt)("p",null,(0,i.kt)("img",{parentName:"p",src:"https://img.shields.io/badge/-configurable-informational",alt:"Configurable"})),(0,i.kt)("h2",{id:"rule-id"},"Rule id"),(0,i.kt)("p",null,"avoid-returning-widgets"),(0,i.kt)("h2",{id:"severity"},"Severity"),(0,i.kt)("p",null,"Warning"),(0,i.kt)("h2",{id:"description"},"Description"),(0,i.kt)("p",null,"Warns when a method, function or getter returns a Widget or subclass of a Widget."),(0,i.kt)("p",null,"The following patterns will not trigger the rule:"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Widget ",(0,i.kt)("inlineCode",{parentName:"li"},"build")," method overrides."),(0,i.kt)("li",{parentName:"ul"},"Class method that is passed to a builder."),(0,i.kt)("li",{parentName:"ul"},"Functions with ",(0,i.kt)("a",{parentName:"li",href:"https://pub.dev/packages/functional_widget"},"functional_widget")," package annotations.")),(0,i.kt)("p",null,"Extracting widgets to a method is considered as a Flutter anti-pattern, because when Flutter rebuilds widget tree, it calls the function all the time, making more processor time for the operations."),(0,i.kt)("p",null,"Consider creating a separate widget instead of a function or method."),(0,i.kt)("p",null,"Additional resources:"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("a",{parentName:"li",href:"https://github.com/flutter/flutter/issues/19269"},"https://github.com/flutter/flutter/issues/19269")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("a",{parentName:"li",href:"https://flutter.dev/docs/perf/rendering/best-practices#controlling-build-cost"},"https://flutter.dev/docs/perf/rendering/best-practices#controlling-build-cost")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("a",{parentName:"li",href:"https://www.reddit.com/r/FlutterDev/comments/avhvco/extracting_widgets_to_a_function_is_not_an/"},"https://www.reddit.com/r/FlutterDev/comments/avhvco/extracting_widgets_to_a_function_is_not_an/")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("a",{parentName:"li",href:"https://medium.com/flutter-community/splitting-widgets-to-methods-is-a-performance-antipattern-16aa3fb4026c"},"https://medium.com/flutter-community/splitting-widgets-to-methods-is-a-performance-antipattern-16aa3fb4026c"))),(0,i.kt)("p",null,"Use ",(0,i.kt)("inlineCode",{parentName:"p"},"ignored-names")," configuration, if you want to ignore a function or method name."),(0,i.kt)("p",null,"Use ",(0,i.kt)("inlineCode",{parentName:"p"},"ignored-annotations")," configuration, if you want to override default ignored annotation list."),(0,i.kt)("p",null,"For example:"),(0,i.kt)("h3",{id:"config-example"},"Config example"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-yaml"},"dart_code_metrics:\n  ...\n  rules:\n    ...\n    - avoid-returning-widgets:\n        ignored-names:\n          - testFunction\n        ignored-annotations:\n          - allowedAnnotation\n")),(0,i.kt)("p",null,"will ignore all functions named ",(0,i.kt)("inlineCode",{parentName:"p"},"testFunction")," and all functions having ",(0,i.kt)("inlineCode",{parentName:"p"},"allowedAnnotation")," annotation."),(0,i.kt)("h3",{id:"example"},"Example"),(0,i.kt)("p",null,"Bad:"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-dart"},"class MyWidget extends StatelessWidget {\n  const MyWidget();\n\n  // LINT\n  Widget _getWidget() => Container();\n\n  Widget _buildShinyWidget() {\n    return Container(\n      child: Column(\n        children: [\n          Text('Hello'),\n          ...\n        ],\n      ),\n    );\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    return Row(\n      children: [\n        Text('Text!'),\n        ...\n        _buildShinyWidget(), // LINT\n      ],\n    );\n  }\n}\n")),(0,i.kt)("p",null,"Good:"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-dart"},"class MyWidget extends StatelessWidget {\n  const MyWidget();\n\n  @override\n  Widget build(BuildContext context) {\n    return Row(\n      children: [\n        Text('Text!'),\n        ...\n        const _MyShinyWidget(),\n      ],\n    );\n  }\n}\n\nclass _MyShinyWidget extends StatelessWidget {\n  const _MyShinyWidget();\n\n  @override\n  Widget build(BuildContext context) {\n    return Container(\n      child: Column(\n        children: [\n          Text('Hello'),\n          ...\n        ],\n      ),\n    );\n  }\n}\n")),(0,i.kt)("p",null,"Good:"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-dart"},"class MyWidget extends StatelessWidget {\n  Widget _buildMyWidget(BuildContext context) {\n    return Container();\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    return Builder(\n      builder: _buildMyWidget,\n    );\n  }\n}\n")))}c.isMDXComponent=!0}}]);