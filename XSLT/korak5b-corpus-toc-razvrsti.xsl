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
            <xsl:for-each-group select="tei:list/tei:item" group-by="@ana">
                <list>
                    <!-- razvrstim skupine po letnicah, zborih in številkah seje -->
                    <xsl:for-each-group select="current-group()" group-by="concat(tokenize(@corresp,'-')[2],'.',substring-after(@sortKey,'#PAR.'),'.',tokenize(tokenize(@corresp,'-')[4],'\.')[1])">
                        <xsl:variable name="leto-stevilo" select="current-grouping-key()"/>
                        <!-- razvrstim po morebitnih številkah sej v atributu n -->
                        <xsl:for-each-group select="current-group()" group-by="@n">
                            <xsl:choose>
                                <xsl:when test="count(current-group()) gt 1">
                                    <item n="{$leto-stevilo}">
                                        <list>
                                            <xsl:for-each select="current-group()">
                                                <xsl:call-template name="item"/>
                                            </xsl:for-each>
                                        </list>
                                    </item>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="current-group()">
                                        <xsl:call-template name="item"/>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                        <!-- posebej razvrstim tiste, ki nimajo ana atributa n -->
                        <xsl:for-each select="current-group()[not(@n)]">
                            <xsl:call-template name="item"/>
                        </xsl:for-each>
                    </xsl:for-each-group>
                </list>
            </xsl:for-each-group>
            <!-- posebej razvrstim tiste, ki nimajo ana atributa -->
            <list>
                <xsl:for-each select="tei:list/tei:item[not(@ana)]">
                    <xsl:call-template name="item"/>
                </xsl:for-each>
            </list>
        </div>
    </xsl:template>
    
    <xsl:template name="item">
        <item>
            <xsl:if test="@ana">
                <xsl:attribute name="ana">
                    <xsl:value-of select="@ana"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@n">
                <xsl:attribute name="n">
                    <xsl:value-of select="@n"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@corresp">
                <xsl:attribute name="corresp">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="tei:p">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="tei:note[tei:p]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="distinct-values(tei:note/@ana)">
                <note ana="{.}"/>
            </xsl:for-each>
        </item>
    </xsl:template>
    
</xsl:stylesheet>