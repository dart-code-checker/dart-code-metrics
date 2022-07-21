"use strict";(self.webpackChunkdart_code_metrics_website=self.webpackChunkdart_code_metrics_website||[]).push([[3554],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>d});var a=n(7294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},o=Object.keys(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var s=a.createContext({}),p=function(e){var t=a.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},c=function(e){var t=p(e.components);return a.createElement(s.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},m=a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,o=e.originalType,s=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),m=p(n),d=r,h=m["".concat(s,".").concat(d)]||m[d]||u[d]||o;return n?a.createElement(h,i(i({ref:t},c),{},{components:n})):a.createElement(h,i({ref:t},c))}));function d(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var o=n.length,i=new Array(o);i[0]=m;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:r,i[1]=l;for(var p=2;p<o;p++)i[p]=n[p];return a.createElement.apply(null,i)}return a.createElement.apply(null,n)}m.displayName="MDXCreateElement"},7903:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>s,contentTitle:()=>i,default:()=>u,frontMatter:()=>o,metadata:()=>l,toc:()=>p});var a=n(7462),r=(n(7294),n(3905));const o={},i="Halstead Volume",l={unversionedId:"metrics/halstead-volume",id:"metrics/halstead-volume",title:"Halstead Volume",description:"The Halstead metrics are based on the numbers of operators and operands.",source:"@site/docs/metrics/halstead-volume.md",sourceDirName:"metrics",slug:"/metrics/halstead-volume",permalink:"/docs/metrics/halstead-volume",draft:!1,editUrl:"https://github.com/dart-code-checker/dart-code-metrics/tree/master/website/docs/metrics/halstead-volume.md",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Cyclomatic Complexity",permalink:"/docs/metrics/cyclomatic-complexity"},next:{title:"Lines of Code",permalink:"/docs/metrics/lines-of-code"}},s={},p=[{value:"Config example",id:"config-example",level:2},{value:"Example",id:"example",level:2}],c={toc:p};function u(e){let{components:t,...n}=e;return(0,r.kt)("wrapper",(0,a.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"halstead-volume"},"Halstead Volume"),(0,r.kt)("p",null,"The Halstead metrics are based on the numbers of operators and operands."),(0,r.kt)("p",null,"First we need to decide what we mean by operators and operands. Operators and operands are defined by their relationship to each other \u2013 in general an operator carries out an action and an operand participates in such action. A simple example of an operator is something that carries out an operation using zero or more operands. An operand is something that may participate in an interaction with zero or more operators. So let\u2019s look at the example:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"int x = x + 1;\n")),(0,r.kt)("p",null,(0,r.kt)("inlineCode",{parentName:"p"},"x")," occurs twice so if we take ",(0,r.kt)("inlineCode",{parentName:"p"},"int"),", ",(0,r.kt)("inlineCode",{parentName:"p"},"x")," and ",(0,r.kt)("inlineCode",{parentName:"p"},"1")," as operands and ",(0,r.kt)("inlineCode",{parentName:"p"},"="),", ",(0,r.kt)("inlineCode",{parentName:"p"},"+")," as operators we have 4 operands (3 unique) and 2 operators (2 unique). Taking ",(0,r.kt)("strong",{parentName:"p"},"OP")," as the number of operators, ",(0,r.kt)("strong",{parentName:"p"},"OD")," as the number of operands, ",(0,r.kt)("strong",{parentName:"p"},"UOP")," as the number of unique operators and ",(0,r.kt)("strong",{parentName:"p"},"UOD")," as the number of unique operands we define the primitive Halstead metrics as:"),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},"The Halstead Length (LTH) is: ",(0,r.kt)("inlineCode",{parentName:"li"},"OP + OD")),(0,r.kt)("li",{parentName:"ul"},"The Halstead Vocabulary (VOC) is: ",(0,r.kt)("inlineCode",{parentName:"li"},"UOP + UOD"))),(0,r.kt)("p",null,"The Halstead Volume is based on the Length and the Vocabulary."),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},"Halstead Volume (VOL) is: ",(0,r.kt)("inlineCode",{parentName:"li"},"LTH * log2(VOC)"))),(0,r.kt)("p",null,"You can view this as the bulk of the code \u2013 how much information does the reader of the code have to absorb to understand its meaning. The biggest influence on the ",(0,r.kt)("inlineCode",{parentName:"p"},"Volume")," metric is the ",(0,r.kt)("inlineCode",{parentName:"p"},"Halstead Length")," which causes a linear increase in the Volume i.e doubling the Length will double the Volume. In case of the Vocabulary the increase is logarithmic. For example with a Length of 10 and a Vocabulary of 16 the Volume is 40. If we double the Length the Volume doubles to 80. If we keep the Length at 10 and double the Vocabulary to 32 we get a volume of 50."),(0,r.kt)("h2",{id:"config-example"},"Config example"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-yaml"},"dart_code_metrics:\n  ...\n  metrics:\n    ...\n    halstead-volume: 150\n    ...\n")),(0,r.kt)("h2",{id:"example"},"Example"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-dart"},"MetricComputationResult<double> computeImplementation(\n  Declaration node,\n  Iterable<ScopedClassDeclaration> classDeclarations,\n  Iterable<ScopedFunctionDeclaration> functionDeclarations,\n  InternalResolvedUnitResult source,\n) {\n  final visitor = HalsteadVolumeAstVisitor();\n  node.visitChildren(visitor);\n\n  final lth = visitor.operators + visitor.operands;\n\n  final voc = visitor.uniqueOperators + visitor.uniqueOperands;\n\n  final vol = lth * _log2(voc);\n\n  return MetricComputationResult<double>(value: vol);\n}\n")),(0,r.kt)("p",null,(0,r.kt)("strong",{parentName:"p"},"Halstead Volume")," for the example function is ",(0,r.kt)("strong",{parentName:"p"},"138"),"."))}u.isMDXComponent=!0}}]);