<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument toc/Sk-11.xml -->
    <!-- premakni XSLT v mapo, kjer procesiraš -->
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <!-- DODAJ NOVI XPATH DO USTREZNE LIST SKUPINE -->
    
    <xsl:param name="delimeter" select="','"/>
    <xsl:variable name="headers">
        <header>"govornik"</header>
        <header>"št. govorov"</header>
        <header>"št. besed"</header>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="$headers/header" separator="{$delimeter}"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <!-- besedilo najprej spravim v variablo, ki jo nato spodaj procesiram -->
        <xsl:variable name="counting">
            <!-- ZAMENJAJ XPATH -->
            <xsl:for-each select="tei:text[1]/tei:body[1]/tei:list[2]/tei:item[3]/tei:list[2]/tei:item[6]/tei:list[1]/tei:item[3]/tei:list[1]/tei:item[3]/tei:list[1]/tei:item[1]/tei:list[1]/tei:item">
                <xsl:variable name="corresp" select="substring-after(@corresp,'corp:')"/>
                <!-- dodan filter za čas -->
                <xsl:for-each select="document('../teiCorpus/Sk-11.xml')//tei:div[@xml:id = $corresp][contains(preceding::tei:stage[@type='time'][tei:time/@from][1]/tei:time/@from,'1991-05')]">
                    <!-- najprej posebej spravim vse odstavke besedila -->
                    <xsl:for-each select="tei:sp/tei:p | tei:sp/tei:ab">
                        <string>
                            <xsl:value-of select="normalize-space(.)"/>
                        </string>
                    </xsl:for-each>
                    <!-- nato razvrstim odstavke besedila v skupine glede na govorca -->
                    <xsl:for-each-group select="tei:sp" group-by="substring-after(@who,'sp:')">
                        <xsl:variable name="string">
                            <xsl:for-each select="current-group()/tei:p | current-group()/tei:ab">
                                <xsl:value-of select="normalize-space(.)"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <speaker id="{current-grouping-key()}" sp="{count(current-group()[tei:speaker])}" word="{count(tokenize($string,'\W+')[. != ''])}"/>
                    </xsl:for-each-group>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each-group select="$counting/speaker" group-by="@id">
            <xsl:variable name="count-list">
                <xsl:for-each select="current-group()">
                    <person-count sp="{@sp}" word="{@word}"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="concat('&quot;',current-grouping-key(),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',sum($count-list//person-count/@sp),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',sum($count-list//person-count/@word),'&quot;')"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each-group>
        
        <!-- posebna datoteka za štetje frekvence besed v celotnem besedilu tematike -->
        <!--<xsl:variable name="compoundString" select="normalize-space(string-join($counting/string,' '))"/>
        <!-\- štetje besed vseh govorov v tematskem sklopu -\->
        <xsl:result-document href="word_frequency.csv">
            <xsl:text>"beseda", "frekvenca"&#xa;</xsl:text>
            <xsl:for-each-group group-by="." select="for $word in tokenize($compoundString,'\W+')[. != ''] return lower-case($word)">
                <xsl:sort select="count(current-group())" order="descending"/>
                <!-\- izloči stopwords -\->
                <xsl:variable name="word" select="current-grouping-key()"/>
                <xsl:variable name="countword" select="count(current-group())"/>
                <xsl:choose>
                    <xsl:when test="$word = document('../XSLT/words/stopwords-sl.xml')/root/w or matches($word,'\d+')">
                        <!-\- če je stopword ali pa številka, jo ne prikažem -\->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('&quot;',$word,'&quot;')"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="concat('&quot;',$countword,'&quot;')"/>
                        <xsl:text>&#xa;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:result-document>-->
        
        <!-- posebna datoteka za izpis vseh besed (vsak odstavek v svoji vrstici) - uporabno za
            Voyant in druge nadaljne aplikacije in orodja, npr. ToTaLe -->
        <!--<xsl:result-document href="text.txt">
            <xsl:for-each select="$counting/string">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
        </xsl:result-document>-->
    </xsl:template>
    
</xsl:stylesheet>