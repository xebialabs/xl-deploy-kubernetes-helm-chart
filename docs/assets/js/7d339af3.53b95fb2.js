"use strict";(self.webpackChunkdocumentation=self.webpackChunkdocumentation||[]).push([[766],{3905:function(e,t,n){n.d(t,{Zo:function(){return d},kt:function(){return m}});var a=n(7294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},i=Object.keys(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var s=a.createContext({}),p=function(e){var t=a.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},d=function(e){var t=p(e.components);return a.createElement(s.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},u=a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,i=e.originalType,s=e.parentName,d=l(e,["components","mdxType","originalType","parentName"]),u=p(n),m=r,g=u["".concat(s,".").concat(m)]||u[m]||c[m]||i;return n?a.createElement(g,o(o({ref:t},d),{},{components:n})):a.createElement(g,o({ref:t},d))}));function m(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=n.length,o=new Array(i);o[0]=u;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:r,o[1]=l;for(var p=2;p<i;p++)o[p]=n[p];return a.createElement.apply(null,o)}return a.createElement.apply(null,n)}u.displayName="MDXCreateElement"},8040:function(e,t,n){n.r(t),n.d(t,{frontMatter:function(){return l},contentTitle:function(){return s},metadata:function(){return p},toc:function(){return d},default:function(){return u}});var a=n(7462),r=n(3366),i=(n(7294),n(3905)),o=["components"],l={sidebar_position:7},s="Upgrading Helm Chart",p={unversionedId:"upgrading-helm-chart",id:"upgrading-helm-chart",isDocsHomePage:!1,title:"Upgrading Helm Chart",description:"To upgrade the version ImageTag parameter needs to be updated to the desired version. To see the list of available ImageTag for Digital.ai Deploy, refer the following links Deploy_tags. For upgrade, Rolling Update strategy is used.",source:"@site/docs/upgrading-helm-chart.md",sourceDirName:".",slug:"/upgrading-helm-chart",permalink:"/xl-deploy-kubernetes-helm-chart/docs/upgrading-helm-chart",tags:[],version:"current",sidebarPosition:7,frontMatter:{sidebar_position:7},sidebar:"tutorialSidebar",previous:{title:"Installing Helm Chart",permalink:"/xl-deploy-kubernetes-helm-chart/docs/installing-helm-chart"},next:{title:"Uninstalling Helm Chart",permalink:"/xl-deploy-kubernetes-helm-chart/docs/uninstalling-helm-chart"}},d=[{value:"Existing or External Databases",id:"existing-or-external-databases",children:[],level:3},{value:"Existing or External Messaging Queue",id:"existing-or-external-messaging-queue",children:[],level:3},{value:"Existing Ingress Controller",id:"existing-ingress-controller",children:[],level:3}],c={toc:d};function u(e){var t=e.components,n=(0,r.Z)(e,o);return(0,i.kt)("wrapper",(0,a.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"upgrading-helm-chart"},"Upgrading Helm Chart"),(0,i.kt)("p",null,"To upgrade the version ",(0,i.kt)("inlineCode",{parentName:"p"},"ImageTag")," parameter needs to be updated to the desired version. To see the list of available ImageTag for Digital.ai Deploy, refer the following links ",(0,i.kt)("a",{parentName:"p",href:"https://hub.docker.com/r/xebialabs/xl-deploy/tags"},"Deploy_tags"),". For upgrade, Rolling Update strategy is used.\nTo upgrade the chart with the release name ",(0,i.kt)("inlineCode",{parentName:"p"},"xld-production"),", execute below command: "),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-bash"},"helm upgrade xld-production xl-deploy-kubernetes-helm-chart/\n")),(0,i.kt)("div",{className:"admonition admonition-note alert alert--secondary"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.3 5.69a.942.942 0 0 1-.28-.7c0-.28.09-.52.28-.7.19-.18.42-.28.7-.28.28 0 .52.09.7.28.18.19.28.42.28.7 0 .28-.09.52-.28.7a1 1 0 0 1-.7.3c-.28 0-.52-.11-.7-.3zM8 7.99c-.02-.25-.11-.48-.31-.69-.2-.19-.42-.3-.69-.31H6c-.27.02-.48.13-.69.31-.2.2-.3.44-.31.69h1v3c.02.27.11.5.31.69.2.2.42.31.69.31h1c.27 0 .48-.11.69-.31.2-.19.3-.42.31-.69H8V7.98v.01zM7 2.3c-3.14 0-5.7 2.54-5.7 5.68 0 3.14 2.56 5.7 5.7 5.7s5.7-2.55 5.7-5.7c0-3.15-2.56-5.69-5.7-5.69v.01zM7 .98c3.86 0 7 3.14 7 7s-3.14 7-7 7-7-3.12-7-7 3.14-7 7-7z"}))),"note")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"Currently upgrading custom plugins and database drivers is not supported.\nIn order to upgrade custom plugins and database drivers, users need to build custom docker image of Digital.ai Deploy\ncontaining required files.See the ",(0,i.kt)("a",{parentName:"p",href:"https://docs.xebialabs.com/v.9.7/deploy/how-to/customize-xl-up/#adding-custom-plugins"},"adding custom plugins"),"\nsection in the the Digital.ai (formerly Xebialabs) official documentation."))),(0,i.kt)("h3",{id:"existing-or-external-databases"},"Existing or External Databases"),(0,i.kt)("p",null,"There is an option to use external PostgreSQL database for your Digital.ai Deploy.\nConfigure values.yaml file accordingly.\nIf you want to use an existing database,  these steps need to be followed:"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Change ",(0,i.kt)("inlineCode",{parentName:"li"},"postgresql.install")," to false"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingDB.Enabled"),": true"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingDB.XL_DB_URL"),": ",(0,i.kt)("inlineCode",{parentName:"li"},"jdbc:postgresql://<postgres-service-name>.<namsepace>.svc.cluster.local:5432/<xld-database-name>")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingDB.XL_DB_USERNAME"),": Database User for xl-deploy"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingDB.XL_DB_PASSWORD"),": Database Password for xl-deploy")),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},"Example:")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-bash"},'#Passing a custom PostgreSQL to XL-Deploy\nUseExistingDB:\n  Enabled: true\n  # If you want to use existing database, change the value to "true".\n  # Uncomment the following lines and provide the values.\n  XL_DB_URL: jdbc:postgresql://xld-production-postgresql.default.svc.cluster.local:5432/xld-db\n  XL_DB_USERNAME: postgres\n  XL_DB_PASSWORD: postgres\n')),(0,i.kt)("div",{className:"admonition admonition-note alert alert--secondary"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.3 5.69a.942.942 0 0 1-.28-.7c0-.28.09-.52.28-.7.19-.18.42-.28.7-.28.28 0 .52.09.7.28.18.19.28.42.28.7 0 .28-.09.52-.28.7a1 1 0 0 1-.7.3c-.28 0-.52-.11-.7-.3zM8 7.99c-.02-.25-.11-.48-.31-.69-.2-.19-.42-.3-.69-.31H6c-.27.02-.48.13-.69.31-.2.2-.3.44-.31.69h1v3c.02.27.11.5.31.69.2.2.42.31.69.31h1c.27 0 .48-.11.69-.31.2-.19.3-.42.31-.69H8V7.98v.01zM7 2.3c-3.14 0-5.7 2.54-5.7 5.68 0 3.14 2.56 5.7 5.7 5.7s5.7-2.55 5.7-5.7c0-3.15-2.56-5.69-5.7-5.69v.01zM7 .98c3.86 0 7 3.14 7 7s-3.14 7-7 7-7-3.12-7-7 3.14-7 7-7z"}))),"note")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"User might have database instance running outside the cluster. Configure parameters accordingly."))),(0,i.kt)("h3",{id:"existing-or-external-messaging-queue"},"Existing or External Messaging Queue"),(0,i.kt)("p",null,"If you plan to use an existing messaging queue, follow these steps to configure values.yaml"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Change ",(0,i.kt)("inlineCode",{parentName:"li"},"rabbitmq-ha.install")," to false"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingMQ.Enabled"),": true"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingMQ.XLD_TASK_QUEUE_USERNAME"),": Username for xl-deploy task queue"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingMQ.XLD_TASK_QUEUE_PASSWORD"),": Password for xl-deploy task queue"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingMQ.XLD_TASK_QUEUE_URL"),": ",(0,i.kt)("inlineCode",{parentName:"li"},"amqp://<rabbitmq-service-name>.<namsepace>.svc.cluster.local:5672")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"UseExistingMQ.XLD_TASK_QUEUE_DRIVER_CLASS_NAME"),": Driver class name for  xl-deploy task queue")),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},"Example:")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-bash"},"# Passing a custom RabbitMQ to XL-Deploy\nUseExistingMQ:\n  Enabled: true\n  # If you want to use an existing Message Queue, change 'rabbitmq-ha.install' to 'false'.\n  # Set 'UseExistingMQ.Enabled' to 'true'.Uncomment the following lines and provide the values.\n  XLD_TASK_QUEUE_USERNAME: guest\n  XLD_TASK_QUEUE_PASSWORD: guest\n  XLD_TASK_QUEUE_URL: amqp://xld-production-rabbitmq-ha.default.svc.cluster.local:5672/%2F\n  XLD_TASK_QUEUE_DRIVER_CLASS_NAME: com.rabbitmq.jms.admin.RMQConnectionFactory\n")),(0,i.kt)("div",{className:"admonition admonition-note alert alert--secondary"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.3 5.69a.942.942 0 0 1-.28-.7c0-.28.09-.52.28-.7.19-.18.42-.28.7-.28.28 0 .52.09.7.28.18.19.28.42.28.7 0 .28-.09.52-.28.7a1 1 0 0 1-.7.3c-.28 0-.52-.11-.7-.3zM8 7.99c-.02-.25-.11-.48-.31-.69-.2-.19-.42-.3-.69-.31H6c-.27.02-.48.13-.69.31-.2.2-.3.44-.31.69h1v3c.02.27.11.5.31.69.2.2.42.31.69.31h1c.27 0 .48-.11.69-.31.2-.19.3-.42.31-.69H8V7.98v.01zM7 2.3c-3.14 0-5.7 2.54-5.7 5.68 0 3.14 2.56 5.7 5.7 5.7s5.7-2.55 5.7-5.7c0-3.15-2.56-5.69-5.7-5.69v.01zM7 .98c3.86 0 7 3.14 7 7s-3.14 7-7 7-7-3.12-7-7 3.14-7 7-7z"}))),"note")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"User might have rabbitmq instance running outside the cluster. Configure parameters accordingly."))),(0,i.kt)("h3",{id:"existing-ingress-controller"},"Existing Ingress Controller"),(0,i.kt)("p",null,"There is an option to use external ingress controller for Digital.ai Deploy.\nIf you want to use an existing ingress controller,  change ",(0,i.kt)("inlineCode",{parentName:"p"},"haproxy.install")," to false."))}u.isMDXComponent=!0}}]);