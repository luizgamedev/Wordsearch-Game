<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
 Caca Palavras
 Arquivo NCL Principal
 @author Luiz

-->

<ncl id="CacaPalavras" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">

<head>

	<regionBase>
		<region id="tv" width="100%" height="100%">
			<region id="regPrincipal" width="100%" height="100%" zIndex="1" />>
		</region>
	</regionBase>



	<descriptorBase>
		<descriptor id="luaDesc" region="regPrincipal" focusIndex="1" />
		<descriptor id="dfundo" region="regPrincipal" focusIndex="2" /> 
	</descriptorBase>
	
	<connectorBase>
		<causalConnector id="onBeginStartN">
			<simpleCondition role="onBegin"/>
			<simpleAction role="start" max="unbounded" qualifier="seq" />
		</causalConnector>
	
	
		<causalConnector id="onKeySelectionStopNStartN">
			<connectorParam name="keyCode" />
			<connectorParam name="var"/>
			<simpleCondition role="onSelection" key="$keyCode"/>
			<compoundAction operator="seq">
				<simpleAction role="stop" max="unbounded" qualifier="seq"/>
				<simpleAction role="start" max="unbounded" qualifier="par"/>
			</compoundAction>
		</causalConnector>
		
		<causalConnector id="onEndStopN">
			<simpleCondition role="onEnd"/>
			<simpleAction role="stop" max="unbounded" qualifier="par" />
		</causalConnector>
	
	</connectorBase>	

</head>	
<body>
	<port id="init" component="fundo"/> 
	
	<!-- midias  -->
	<!-- <port id="int" component="luaApp" /> -->

	<media id="fundo" type="image/png" src="img/bkJogo.png" descriptor="dfundo" />
	<media id="somJogo" type="audio/mp3" src="media/somJogo.mp3"  />
	<media id="somJogo2" type="audio/mp3" src="media/somJogoMetal.mp3"  />
	
	<!--
	<media type="application/x-ginga-settings" id="programSettings2">
		<property name="service.currentFocus" value="1" />
	</media>
	-->
	<media type="application/x-ginga-settings" id="programSettings">
	        <property name="service.currentKeyMaster" value="1"/>
	</media>


	<media id="luaApp" type="application/x-ginga-NCLua" src="luaStuff/main.lua" descriptor="luaDesc">
	</media>


	<link xconnector="onBeginStartN">
		<bind role="onBegin" component="fundo"/>
		<bind role="start" component="fundo"/>
	</link>	
	
	<link xconnector="onKeySelectionStopNStartN">
		<linkParam name="keyCode" value="RED" />
		<bind component="fundo" role="onSelection" />
		<bind role="stop" component="fundo"/> 
		<bind role="start" component="luaApp"/>
		<bind component="programSettings" role="set" interface="service.currentKeyMaster">
				<bindParam name="var" value="2"/>
		</bind> 
		
	</link>	
	
	<!--
	
	<link xconnector="onBeginStartN">
		<bind role="onBegin" component="luaApp"/>
		<bind role="start" component="somJogo"/>
	</link>
	
	<link xconnector="onEndStopN">
		<bind role="onEnd" component="luaApp" />
		<bind role="stop" component="somJogo"/>
	</link>
	
	-->

	</body>
</ncl>