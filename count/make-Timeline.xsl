<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument teiCorpus/Sk-11.xml -->
    <!-- premakni XSLT v mapo izhodiščnega dokumenta -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="tei:teiCorpus">
        <xsl:result-document href="SlovParl-timeline-data.xml">
            <data date-time-format="iso8601">
                <xsl:for-each select="//tei:timeline">
                    <xsl:variable name="teiID" select="ancestor::tei:TEI/@xml:id"/>
                    <xsl:variable name="chamber" select="tokenize($teiID,'-')[3]"/>
                    <xsl:variable name="sessionNu" select="tokenize($teiID,'-')[4]"/>
                    <xsl:for-each select="tei:when[@xml:id]">
                        <xsl:variable name="whenID" select="@xml:id"/>
                        <xsl:variable name="position">
                            <xsl:choose>
                                <xsl:when test="position() = 1">first</xsl:when>
                                <xsl:when test="position() = last()">last</xsl:when>
                                <xsl:otherwise>middle</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="endTime" select="following-sibling::tei:when[@since = concat('#',$whenID)]/@absolute"/>
                        <xsl:variable name="endTimeInterval" select="following-sibling::tei:when[@since = concat('#',$whenID)]/@interval"/>
                        <event>
                            <xsl:attribute name="start">
                                <xsl:choose>
                                    <xsl:when test="contains(@absolute,'T')">
                                        <xsl:value-of select="concat(@absolute,'+02:00')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat(@absolute,'T00:00:00+02:00')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:if test="not(contains(@absolute,'T'))">
                                <xsl:attribute name="earliestStart">
                                    <xsl:value-of select="concat(@absolute,'T00:00:00+02:00')"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="end">
                                <xsl:choose>
                                    <xsl:when test="string-length($endTimeInterval) = 0">
                                        <xsl:value-of select="concat(following-sibling::tei:when[contains(@absolute,'T')][1]/@absolute,'+02:00')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="contains($endTime,'T')">
                                                <xsl:value-of select="concat($endTime,'+02:00')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat(following-sibling::tei:when[contains(@absolute,'T')][1]/@absolute,'+02:00')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:if test="string-length($endTimeInterval) = 0 or not(contains($endTime,'T'))">
                                <xsl:attribute name="latestEnd">
                                    <xsl:value-of select="concat(following-sibling::tei:when[contains(@absolute,'T')][1]/@absolute,'+02:00')"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="color">
                                <xsl:choose>
                                    <xsl:when test="$chamber = 'DruzPolZb'">red</xsl:when>
                                    <xsl:when test="$chamber = 'ZbObc'">green</xsl:when>
                                    <xsl:when test="$chamber = 'ZbZdruDel'">black</xsl:when>
                                    <xsl:otherwise>blue</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <!-- opis -->
                            <xsl:value-of select="$chamber"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="concat('št. ',$sessionNu)"/>
                            <xsl:text>, </xsl:text>
                            <xsl:choose>
                                <xsl:when test="$position = 'first'">začetek</xsl:when>
                                <xsl:when test="$position = 'last'">konec</xsl:when>
                                <xsl:otherwise>nadaljevanje </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text> </xsl:text>
                            <xsl:choose>
                                <xsl:when test="$chamber = 'Zasedanje'">
                                    <xsl:text>zasedanja</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>seje</xsl:otherwise>
                            </xsl:choose>
                        </event>
                    </xsl:for-each>
                </xsl:for-each>
            </data>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>