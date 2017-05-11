<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodišče: tei-list2.xml -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="actors">
        <xsl:for-each select="document('../temp/XML/actors2.xml')/root/actor/id">
            <id xml:id="{../@xml:id}">
                <xsl:value-of select="."/>
            </id>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="documentsList">
        <xsl:for-each select="ref">
            <xsl:variable name="document" select="concat('rezultat/',.)"/>
            <xsl:result-document href="{$document}">
                <xsl:apply-templates select="document(.)"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:sp[@who]">
        <xsl:variable name="ID" select="substring-after(@who,'#')"/>
        <sp>
            <xsl:attribute name="who">
                <xsl:for-each select="$actors/tei:id[concat(tokenize(.,' ')[2],'.',tokenize(.,' ')[1]) eq $ID]">
                    <xsl:value-of select="concat('sp:',@xml:id)"/>
                </xsl:for-each>
            </xsl:attribute>
            <xsl:attribute name="corresp">
                <xsl:value-of select="@who"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </sp>
    </xsl:template>
    
</xsl:stylesheet>