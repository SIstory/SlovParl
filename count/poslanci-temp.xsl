<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <!-- Parameter, s katerim določimo, katero skupino ljudi naj izpiše.
         Možne vrednosti:
           - president (predsedujoči seje)
         Če je parameter nima ene od teh možnosti, se izpiše za vse govornike.
    -->
    
    <xsl:param name="delimeter" select="','"/>
    <xsl:variable name="headers">
        <header>"govornik"</header>
        <header>"id"</header>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="$headers/header" separator="{$delimeter}"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="tei:TEI/tei:text[1]/tei:body[1]/tei:listPerson[2]/tei:person">
            <xsl:variable name="name">
                <xsl:choose>
                    <xsl:when test="tei:persName[tei:surname]">
                        <xsl:value-of select="concat(tei:persName[1]/tei:surname[1],' ',tei:persName[1]/tei:forename[1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="tei:persName"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat('&quot;',$name,'&quot;')"/>
            <xsl:value-of select="$delimeter"/>
            <xsl:value-of select="concat('&quot;',@xml:id,'&quot;')"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>