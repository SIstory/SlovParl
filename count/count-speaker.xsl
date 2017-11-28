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
    
    <!-- Parameter, s katerim določimo, katero skupino ljudi naj izpiše.
         Možne vrednosti:
           - president (predsedujoči seje)
         Če je parameter nima ene od teh možnosti, se izpiše za vse govornike.
    -->
    <xsl:param name="role">president</xsl:param>
    
    <xsl:param name="delimeter" select="','"/>
    <xsl:variable name="headers">
        <header>"govornik"</header>
        <!-- veljajo samo unikatni govori (ne štejem tistih, ki so bili prekinjeni z div) -->
        <header>"št. govorov"</header>
        <header>"št. besed"</header>
        <header>"spol"</header>
        <header>"rojstvo"</header>
        <header>"član zbora"</header>
        <header>"član vlade"</header>
        <!-- ni član zbora ali vlade, se pravi, da je zunanji poročevalec - govornik -->
        <header>"ni član"</header>
        <header>"stranka"</header>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="$headers/header" separator="{$delimeter}"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:teiCorpus">
        <!-- besedilo najprej spravim v variablo, ki jo nato spodaj procesiram -->
        <xsl:variable name="counting">
            <!-- najprej posebej spravim vse odstavke besedila -->
            <xsl:for-each select="//tei:sp/tei:p | //tei:sp/tei:ab">
                <string>
                    <xsl:value-of select="normalize-space(.)"/>
                </string>
            </xsl:for-each>
            <!-- nato razvrstim odstavke besedila v skupine glede na govorca -->
            <!-- glede na parameter role -->
            <xsl:choose>
                <xsl:when test="$role = 'president'">
                    <xsl:for-each-group select="//tei:sp" group-by="substring-after(@who,'sp:')">
                        <xsl:call-template name="speaker"/>
                    </xsl:for-each-group>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each-group select="//tei:sp" group-by="substring-after(@who,'sp:')">
                        <xsl:call-template name="speaker"/>
                    </xsl:for-each-group>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="document('../speaker.xml')//tei:person[@xml:id = $counting/speaker/@id]">
            <xsl:variable name="name">
                <xsl:choose>
                    <xsl:when test="tei:persName[tei:surname]">
                        <xsl:value-of select="concat(tei:persName[1]/tei:surname[1],' ',tei:persName[1]/tei:forename[1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="tei:persName"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ID" select="@xml:id"/>
            <xsl:variable name="count-list">
                <xsl:for-each select="$counting/speaker[@id = $ID]">
                    <person-count sp="{@sp}" word="{@word}"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="sex" select="tei:sex/@value"/>
            <xsl:variable name="birth" select="tokenize(tei:birth/@when,'-')[1]"/>
            <xsl:variable name="member">
                <xsl:for-each select="tei:affiliation[contains(@ana,'#parl.Skup-11')]">
                    <xsl:value-of select="substring-after(@ref,'#parl.')"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="government ">
                <xsl:choose>
                    <xsl:when test="tei:affiliation[@ref='#gov.VladaRS']">1</xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="additional">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:listPerson[@type='additional']">1</xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="politicalParty">
                <xsl:variable name="REF">
                    <xsl:for-each select="tei:affiliation[contains(@ana,'#parl.Skup-11')]">
                        <refID id="{substring-after(@ref,'#')}"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="listPolPart">
                    <xsl:for-each select="//tei:org[ancestor::tei:listOrg/tei:head = 'Seznam političnih organizacij v Sloveniji'][@xml:id = $REF/refID/@id]">
                        <polOrg>
                            <xsl:choose>
                                <xsl:when test="tei:orgName[@full='init']">
                                    <xsl:value-of select="tei:orgName[@full='init'][1]"/>
                                </xsl:when>
                                <!-- neodvisni poslanci nimajo kratice -->
                                <xsl:otherwise>
                                    <xsl:value-of select="tei:orgName[1]"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </polOrg>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:for-each select="$listPolPart/polOrg">
                    <xsl:choose>
                        <xsl:when test="position() eq last()">
                            <xsl:value-of select="."/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(.,', ')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:value-of select="concat('&quot;',$name,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',sum($count-list//person-count/@sp),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',sum($count-list//person-count/@word),'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$sex,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$birth,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$member,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$government,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$additional,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$politicalParty,'&quot;')"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        
        <!-- izpis vseh spregovorjenih besed v korpusu -->
        <!-- posebna datoteka za štetje frekvence besed -->
        <xsl:variable name="compoundString" select="normalize-space(string-join($counting/string,' '))"/>
        <xsl:result-document href="word_frequency-corpus.csv">
            <xsl:text>"beseda", "frekvenca"&#xa;</xsl:text>
            <xsl:for-each-group group-by="." select="for $word in tokenize($compoundString,'\W+')[. != ''] return lower-case($word)">
                <xsl:sort select="count(current-group())" order="descending"/>
                <!-- izloči stopwords -->
                <xsl:variable name="word" select="current-grouping-key()"/>
                <xsl:variable name="countword" select="count(current-group())"/>
                <xsl:choose>
                    <xsl:when test="$word = document('../words/stopwords-sl.xml')/root/w or matches($word,'\d+')">
                        <!-- če je stopword ali pa številka, jo ne prikažem -->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('&quot;',$word,'&quot;')"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="concat('&quot;',$countword,'&quot;')"/>
                        <xsl:text>&#xa;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:result-document>
        
        <!-- posebna datoteka za izpis vseh besed (vsak odstavek v svoji vrstici) - uporabno za
            Voyant in druge nadaljne aplikacije in orodja, npr. ToTaLe -->
        <xsl:result-document href="text-corpus.txt">
            <xsl:for-each select="$counting/string">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="speaker">
        <xsl:variable name="string">
            <xsl:for-each select="current-group()/tei:p | current-group()/tei:ab">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <speaker id="{current-grouping-key()}" sp="{count(current-group()[tei:speaker])}" word="{count(tokenize(normalize-space($string),'\W+')[. != ''])}"/>
    </xsl:template>
    
</xsl:stylesheet>