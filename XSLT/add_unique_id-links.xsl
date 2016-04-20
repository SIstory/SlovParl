<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodišče: tei-list.xml -->
    
    <xsl:output method="xml" indent="yes"/>
    
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
    
    <xsl:template match="node()[@xml:id][not(self::tei:TEI)]">
        <xsl:variable name="ID" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:element name="{node-name(.)}">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat($ID,'.',@xml:id)"/>
            </xsl:attribute>
            <!-- div ima lahko tudi @corresp, kjer se sklicuje na item v kazalu v front -->
            <xsl:if test="@corresp">
                <xsl:variable name="sklicCorresp" select="substring-after(@corresp,'#')"/>
                <xsl:attribute name="corresp">
                    <xsl:value-of select="concat('#',$ID,'.',$sklicCorresp)"/>
                </xsl:attribute>
            </xsl:if>
            <!-- v timetable ima lahko @synch tako element z @xml:id kot brez (glej spodnji template) @xml:id -->
            <xsl:if test="@synch">
                <xsl:variable name="sklicSynch" select="substring-after(@synch,'#')"/>
                <xsl:attribute name="synch">
                    <xsl:value-of select="concat('#',$ID,'.',$sklicSynch)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="node()[not(@xml:id)][@sameAs | @who | @synch | @since]">
        <xsl:variable name="ID" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:element name="{node-name(.)}">
            <xsl:apply-templates select="@*"/>
            <xsl:if test="@sameAs">
                <xsl:variable name="sklicSameAs" select="substring-after(@sameAs,'#')"/>
                <xsl:attribute name="sameAs">
                    <xsl:value-of select="concat('#',$ID,'.',$sklicSameAs)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@who">
                <xsl:variable name="sklicWho" select="substring-after(@who,'#')"/>
                <xsl:attribute name="who">
                    <xsl:value-of select="concat('#',$ID,'.',$sklicWho)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@synch">
                <xsl:variable name="sklicSynch" select="substring-after(@synch,'#')"/>
                <xsl:attribute name="synch">
                    <xsl:value-of select="concat('#',$ID,'.',$sklicSynch)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@since">
                <xsl:variable name="sklicSince" select="substring-after(@since,'#')"/>
                <xsl:attribute name="since">
                    <xsl:value-of select="concat('#',$ID,'.',$sklicSince)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@origin">
                <xsl:variable name="sklicOrigin" select="substring-after(@origin,'#')"/>
                <xsl:attribute name="origin">
                    <xsl:value-of select="concat('#',$ID,'.',$sklicOrigin)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
</xsl:stylesheet>