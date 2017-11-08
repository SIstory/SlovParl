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
        <!-- besedilo najprej spravim v variablo, ki jo nato spodaj procesiram -->
        <xsl:variable name="paragraph">
            <xsl:for-each select="//tei:sp/tei:p | //tei:sp/tei:ab">
                <string notBefore="{preceding::tei:stage[tei:time[@from]][1]/tei:time/@from}"
                    notAfter="{following::tei:stage[@type='time'][tei:time/@to][1]/tei:time/@to}" 
                    word="{count(tokenize(normalize-space(.),'\W+')[. != ''])}"
                    type="{tokenize(ancestor::tei:TEI/@xml:id,'-')[3]}" typeNumber="{tokenize(ancestor::tei:TEI/@xml:id,'-')[4]}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="countTime-months.csv">
            <xsl:text>"datum", "št. besed"&#xa;</xsl:text>
            <xsl:for-each-group select="$paragraph/string" group-by="concat(tokenize(@notBefore,'-')[1],'-',tokenize(@notBefore,'-')[2])">
                <xsl:value-of select="concat('&quot;',current-grouping-key(),'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="sum(current-group()/@word)"/>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each-group>
        </xsl:result-document>
        <xsl:result-document href="countTime-months-chambers.csv">
            <xsl:text>"zbor","datum","št. besed"&#xa;</xsl:text>
            <xsl:for-each-group select="$paragraph/string" group-by="@type">
                <xsl:variable name="zbor" select="current-grouping-key()"/>
                <xsl:for-each-group select="current-group()" group-by="concat(tokenize(@notBefore,'-')[1],'-',tokenize(@notBefore,'-')[2])">
                    <xsl:value-of select="concat('&quot;',$zbor,'&quot;')"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="concat('&quot;',current-grouping-key(),'&quot;')"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="sum(current-group()/@word)"/>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </xsl:result-document>
        <xsl:result-document href="countTime-days.csv">
            <xsl:text>"datum","št. besed"&#xa;</xsl:text>
            <xsl:for-each-group select="$paragraph/string" group-by="tokenize(@notBefore,'T')[1]">
                <xsl:value-of select="concat('&quot;',current-grouping-key(),'&quot;')"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="sum(current-group()/@word)"/>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each-group>
        </xsl:result-document>
        <xsl:result-document href="countTime-days-chambers.csv">
            <xsl:text>"zbor","št. seje","datum","št. besed"&#xa;</xsl:text>
            <xsl:for-each-group select="$paragraph/string" group-by="@type">
                <xsl:variable name="zbor" select="current-grouping-key()"/>
                <xsl:for-each-group select="current-group()" group-by="tokenize(@notBefore,'T')[1]">
                    <xsl:variable name="stSeje">
                        <xsl:for-each-group select="current-group()" group-by="@typeNumber">
                            <seja>
                                <xsl:value-of select="current-grouping-key()"/>
                            </seja>
                        </xsl:for-each-group>
                    </xsl:variable>
                    <xsl:variable name="seje">
                        <xsl:for-each select="$stSeje/seja">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="concat('&quot;',$zbor,'&quot;')"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="concat('&quot;',$seje,'&quot;')"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="concat('&quot;',current-grouping-key(),'&quot;')"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="sum(current-group()/@word)"/>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>