<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument teiCorpus/Sk-11.xml -->
    <!-- premakni XSLT v mapo izhodiščnega dokumenta -->
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="tei:teiCorpus">
        <xsl:variable name="stages">
            <xsl:for-each select="//tei:ab">
                <stage type="interruption" 
                    chamber="{tokenize(ancestor::tei:TEI/@xml:id,'-')[3]}" 
                    chamberNum="{tokenize(ancestor::tei:TEI/@xml:id,'-')[4]}" 
                    time="{preceding::tei:stage[tei:time[@from]][1]/tei:time/@from}"/>
            </xsl:for-each>
            <xsl:for-each select="//tei:stage[@type='gap'] | 
                //tei:stage[@type='vocal'] | 
                //tei:stage[@type='incident'] | 
                //tei:stage[@type='kinesic']">
                <stage type="{@type}" 
                    chamber="{tokenize(ancestor::tei:TEI/@xml:id,'-')[3]}" 
                    chamberNum="{tokenize(ancestor::tei:TEI/@xml:id,'-')[4]}" 
                    time="{preceding::tei:stage[tei:time[@from]][1]/tei:time/@from}"/>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:result-document href="countStages-months.csv">
            <xsl:text>"datum","št. prekinitev"&#xa;</xsl:text>
            <xsl:for-each-group select="$stages/stage" group-by="concat(tokenize(@time,'-')[1],'-',tokenize(@time,'-')[2])">
                <xsl:value-of select="concat('&quot;',current-grouping-key(),'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="number(count(current-group()))"/>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each-group>
        </xsl:result-document>
        
        <xsl:result-document href="countStages-type-months.csv">
            <xsl:text>"vrsta","datum","št."&#xa;</xsl:text>
            <xsl:for-each-group select="$stages/stage" group-by="@type">
                <xsl:variable name="vrsta" select="current-grouping-key()"/>
                <xsl:for-each-group select="current-group()" group-by="concat(tokenize(@time,'-')[1],'-',tokenize(@time,'-')[2])">
                    <xsl:value-of select="concat('&quot;',$vrsta,'&quot;')"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="concat('&quot;',current-grouping-key(),'&quot;')"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="number(count(current-group()))"/>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>