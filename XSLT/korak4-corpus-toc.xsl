<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument teiCorpus, ki vključuje vse TEI dokumente s sejami, ki še niso vključene v skupno kazalo -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="tei:teiCorpus">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Title</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <div type="contents">
                        <list>
                            <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:div/tei:div">
                                <item>
                                    <xsl:if test="ancestor::tei:body/tei:div/@ana">
                                        <xsl:attribute name="sortKey">
                                            <xsl:value-of select="ancestor::tei:body/tei:div/@ana"/>
                                        </xsl:attribute>
                                    </xsl:if>
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
                                    <xsl:attribute name="corresp">
                                        <xsl:value-of select="concat('corp:',@xml:id)"/>
                                    </xsl:attribute>
                                    <xsl:variable name="povezava-toc" select="substring-after(@corresp,'#')"/>
                                    <p>
                                        <xsl:apply-templates select="ancestor::tei:text/tei:front/tei:div[@type='contents']//tei:item[@xml:id eq $povezava-toc]" mode="toc"/>
                                    </p>
                                    <xsl:if test="tei:sp/tei:p/tei:title">
                                        <note>
                                            <xsl:for-each select="tei:sp/tei:p/tei:title">
                                                <p>
                                                    <xsl:value-of select="."/>
                                                </p>
                                            </xsl:for-each>
                                        </note>
                                    </xsl:if>
                                    <!-- Ministrstva na razprave v parlament pošiljajo poročevalce o točki dnevnega reda (predlog zakona ipd.),
                                         zato informacija o tem, iz katerega ministrstva so se udeležili razprav, razkriva tudi področje
                                         obravnavane točke dnevnega reda (npr. finance, če je govornik iz ministrstva za finance) -->
                                    <xsl:for-each select="tei:sp/@who">
                                        <xsl:variable name="idPerson" select="substring-after(.,'sp:')"/>
                                        <xsl:for-each select="document('../speaker.xml')//tei:person[@xml:id = $idPerson]">
                                            <xsl:for-each select="tei:affiliation/@ref[contains(.,'#gov.')]">
                                                <note ana="{concat('sp:',substring-after(.,'#'))}"/>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </item>
                            </xsl:for-each>
                        </list>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    <xsl:template match="tei:item[ancestor::tei:div[@type='contents']][@xml:id]" mode="toc">
        <xsl:apply-templates mode="toc"/>
    </xsl:template>
    
    <xsl:template match="tei:list" mode="toc">
        <xsl:choose>
            <xsl:when test="tei:head">
                <!-- ne procesira -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>