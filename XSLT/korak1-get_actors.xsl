<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- izhodiščni dokument je tei-list*.xml -->
    <!-- Premakni ta XSLT v direktorij, kjer se nahaja izhodiščni dokument -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="documentsList">
        <root>
            <xsl:variable name="actors">
                <xsl:for-each select="ref">
                    <xsl:apply-templates select="document(.)"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each-group select="$actors/tei:actor" group-by=".">
                <xsl:sort select="current-grouping-key()"/>
                <actor>
                    <name>
                        <xsl:value-of select="current-grouping-key()"/>
                    </name>
                    <xsl:for-each select="current-group()">
                        <id>
                            <xsl:value-of select="concat(@xml:id,' ',@docTEIid)"/>
                        </id>
                    </xsl:for-each>
                </actor>
            </xsl:for-each-group>
        </root>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:variable name="docTEIid" select="@xml:id"/>
        <xsl:for-each select="//tei:actor[@xml:id]">
            <tei:actor xml:id="{@xml:id}" docTEIid="{$docTEIid}">
                <xsl:value-of select="."/>
            </tei:actor>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>