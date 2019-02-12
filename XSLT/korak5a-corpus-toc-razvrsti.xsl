<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="tei:TEI">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="tei:teiHeader"/>
            <xsl:apply-templates select="tei:text"/>
        </TEI>
    </xsl:template>
    
    <xsl:template match="tei:text">
        <text>
            <xsl:apply-templates select="tei:body"/>
        </text>
    </xsl:template>
    <xsl:template match="tei:body">
        <body>
            <xsl:apply-templates select="tei:div"/>
        </body>
    </xsl:template>
    <xsl:template match="tei:div">
        <div type="contents">
            <list>
                <xsl:for-each select="tei:list/tei:item">
                    <xsl:sort>
                        <xsl:choose>
                            <xsl:when test=" string-length(tei:p) gt 0">
                                <xsl:value-of select="normalize-space(tei:p)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(tei:note/tei:p[1])"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:sort>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </list>
        </div>
    </xsl:template>
    
</xsl:stylesheet>