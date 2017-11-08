<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument teiCorpus/Sk-11.xml -->
    <!-- premakni XSLT v mapo, kjer procesiraš -->
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:param name="delimeter" select="','"/>
    <xsl:variable name="headers">
        <header>"naslov"</header>
        <header>"oznaka1"</header>
        <header>"oznaka2"</header>
        <header>"oznaka3"</header>
        <header>"oznaka4"</header>
        <header>"oznaka5"</header>
        <header>"št. delov"</header>
        <header>"št. govorov"</header>
        <header>"št. besed"</header>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="$headers/header" separator="{$delimeter}"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:teiCorpus">
        <xsl:variable name="counting">
            <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:div/tei:div">
                <xsl:variable name="string" select="normalize-space(string-join(tei:sp/tei:p | tei:sp/tei:ab,' '))"/>
                <div id="{@xml:id}" sp="{count(tei:sp)}" word="{count(tokenize($string,'\W+')[. != ''])}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="document('../toc/Sk-11.xml')//tei:list[tei:head]">
            <xsl:variable name="count-list">
                <xsl:for-each select="tei:item">
                    <xsl:variable name="ID" select="substring-after(@corresp,'corp:')"/>
                    <xsl:for-each select="$counting/div[@id = $ID]">
                        <div-count sp="{@sp}" word="{@word}"/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="concat('&quot;',normalize-space(tei:head),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',normalize-space(ancestor::tei:item[tei:term][position() = last()]/tei:term[1]),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',normalize-space(ancestor::tei:item[tei:term][position() = last()-1]/tei:term[1]),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',normalize-space(ancestor::tei:item[tei:term][position() = last()-2]/tei:term[1]),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',normalize-space(ancestor::tei:item[tei:term][position() = last()-3]/tei:term[1]),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',normalize-space(ancestor::tei:item[tei:term][position() = last()-4]/tei:term[1]),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',count($count-list/div-count),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',sum($count-list//div-count/@sp),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',sum($count-list//div-count/@word),'&quot;')"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>