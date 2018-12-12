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
        <xsl:result-document href="count-sessions.csv">
            <xsl:text>"chamber","sessionNo","daysNo","from","to","interruptions","missingTime","words","interval"&#xa;</xsl:text>
            <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:timeline">
                <xsl:variable name="fileID" select="ancestor::tei:TEI/@xml:id"/>
                <xsl:variable name="chamber" select="tokenize($fileID,'-')[3]"/>
                <xsl:variable name="sessionNo" select="tokenize($fileID,'-')[4]"/>
                <xsl:variable name="days">
                    <xsl:for-each select="tei:when/@absolute">
                        <day>
                            <xsl:value-of select="tokenize(.,'T')[1]"/>
                        </day>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="distinct-days" select="distinct-values($days/day)"/>
                <xsl:variable name="daysNo">
                    <xsl:for-each select="$distinct-days">
                        <day>
                            <xsl:value-of select="."/>
                        </day>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="string">
                    <xsl:for-each select="ancestor::tei:body/tei:div/tei:div/tei:div/tei:div/tei:sp/tei:p | ancestor::tei:body/tei:div/tei:div/tei:div/tei:div/tei:sp/tei:ab">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                
                <xsl:value-of select="concat('&quot;',$chamber,'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat('&quot;',$sessionNo,'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat('&quot;',count($daysNo/day),'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat('&quot;',$daysNo/day[1],'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat('&quot;',$daysNo/day[last()],'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat('&quot;',count(tei:when[@xml:id]) - 1,'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat('&quot;',count(tei:when[@since][not(@interval)]),'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat('&quot;',count(tokenize(normalize-space($string),'\W+')[. != '']),'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat('&quot;',sum(tei:when/@interval),'&quot;')"/>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>