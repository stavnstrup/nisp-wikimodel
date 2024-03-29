<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>

<xsl:output method="text" indent="yes"/>

<xsl:variable name="datadir" select="'./build/data/pages/Main/'" />


<xsl:template match="standards">
  <xsl:apply-templates select="organisations/orgkey" />
  <xsl:apply-templates select="taxonomy/node" />
  <xsl:apply-templates select="records/standard" />
  <xsl:apply-templates select="records/coverdoc" />
  <xsl:apply-templates select="records/profilespec" />
  <xsl:apply-templates select="records/profile" />
  <xsl:apply-templates select="records/serviceprofile" />
</xsl:template>


<!-- Create a Wiki page for an organisation -->

<xsl:template match="orgkey">
<xsl:variable name="uc-key" select="upper-case(@key)"/>
<xsl:result-document href="{$datadir}/{$uc-key}.page">
<xsl:text>{{Organization&#x0A;</xsl:text>
<xsl:text>|acronym=</xsl:text><xsl:value-of select="upper-case(@short)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|description=</xsl:text><xsl:value-of select="@long"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|website=</xsl:text><xsl:value-of select="@uri"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>


<!-- Create a Wiki page for a Taxonomy Node -->

<xsl:template match="node">
<xsl:result-document href="{$datadir}/{@title}.page">
<xsl:text>{{Taxonomy Node&#x0A;</xsl:text>
<xsl:choose>
  <xsl:when test="@emUUID = ''"><xsl:text>|uuid=</xsl:text><xsl:value-of select="@id"/><xsl:text>&#x0A;</xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>|uuid=</xsl:text><xsl:value-of select="@emUUID"/><xsl:text>&#x0A;</xsl:text></xsl:otherwise>
</xsl:choose>
<xsl:if test="not(name(parent::node) eq 'taxonomy')">
<xsl:text>|order=</xsl:text><xsl:number from="standards/taxonomy" count="node" level="any"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|parent=</xsl:text><xsl:value-of select="translate(parent::node/@title, ' ', '_')"/><xsl:text>&#x0A;</xsl:text>
</xsl:if>
<xsl:text>|title=</xsl:text><xsl:value-of select="@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|description=</xsl:text><xsl:value-of select="@description"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
<xsl:apply-templates/>
</xsl:template>


<!-- Create a Wiki page for a Standard -->

<xsl:template match="standard">
<xsl:variable name="myid" select="@id"/>
<xsl:if test="not(.//event[(position()=last()) and (@flag='deleted')])">
<xsl:result-document href="{$datadir}/{@id}.page">
<xsl:text>{{Standard&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|publisher=</xsl:text><xsl:value-of select="upper-case(document/@orgid)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|code=</xsl:text><xsl:value-of select="document/@pubnum"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="document/@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|dateissued=</xsl:text><xsl:value-of select="document/@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|substandards=&#x0A;</xsl:text><xsl:apply-templates select="document/substandards/substandard"/>
<xsl:text>|description=</xsl:text><xsl:apply-templates select="applicability"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|responsible=</xsl:text><xsl:value-of select="upper-case(responsibleparty/@rpref)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|website=</xsl:text><xsl:value-of select="status/uri"/><xsl:text>&#x0A;</xsl:text>
<xsl:apply-templates select="status"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:if>
</xsl:template>

<xsl:template match="substandard"><xsl:value-of select="@refid"/><xsl:text>;&#x0A;</xsl:text></xsl:template>

<!-- Create a Wiki page for a Cover Document -->

<xsl:template match="coverdoc">
<xsl:variable name="myid" select="@id"/>
<xsl:if test="not(.//event[(position()=last()) and (@flag='deleted')])">
<xsl:result-document href="{$datadir}/{@id}.page">
<xsl:text>{{Cover Document&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|publisher=</xsl:text><xsl:value-of select="upper-case(document/@orgid)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|code=</xsl:text><xsl:value-of select="document/@pubnum"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="document/@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|dateissued=</xsl:text><xsl:value-of select="document/@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|substandards=&#x0A;</xsl:text><xsl:apply-templates select="coverstandards/refstandard"/>
<xsl:text>|responsible=</xsl:text><xsl:value-of select="upper-case(responsibleparty/@rpref)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|website=</xsl:text><xsl:value-of select="status/uri"/><xsl:text>&#x0A;</xsl:text>
<xsl:apply-templates select="status"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:if>
</xsl:template>

<!-- Create a Wiki page for a Profile Specification -->

<xsl:template match="profilespec">
<xsl:result-document href="{$datadir}/{@title}.page">
<xsl:text>{{Profile Specification&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|publisher=</xsl:text><xsl:value-of select="upper-case(@orgid)"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|code=</xsl:text><xsl:value-of select="@pubnum"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|dateissued=</xsl:text><xsl:value-of select="@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|version=</xsl:text><xsl:value-of select="@version"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>



<!-- Create a Wiki page for a Profile -->

<xsl:template match="profile">
<xsl:result-document href="{$datadir}/{@title}.page">
<xsl:text>{{Profile&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|shorttitle=</xsl:text><xsl:value-of select="@short"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|toplevel=</xsl:text><xsl:value-of select="@toplevel"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|profspec=</xsl:text><xsl:apply-templates select="refprofilespec" mode="list-profilespec"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|guideline=</xsl:text><xsl:apply-templates select="description"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|profiles=</xsl:text><xsl:apply-templates select="subprofiles/refprofile" mode="list-profiles"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|serviceprofiles=</xsl:text><xsl:apply-templates select="subprofiles/refprofile" mode="list-serviceprofiles"/><xsl:text>&#x0A;</xsl:text>
<xsl:apply-templates select="status"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>


<!-- Create a Wiki page for a Service Profile -->

<xsl:template match="serviceprofile">
<xsl:result-document href="{$datadir}/{@title}.page">
<xsl:text>{{Service Profile&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|profspec=</xsl:text><xsl:apply-templates select="refprofilespec" mode="list-profilespec"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|description=</xsl:text><xsl:apply-templates select="description"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|taxonomynodes=</xsl:text><xsl:apply-templates select="reftaxonomy"/>
<xsl:text>|references=</xsl:text><xsl:apply-templates select="refgroup"/>
<xsl:text>|guideline=</xsl:text><xsl:apply-templates select="description"/><xsl:text>&#x0A;</xsl:text>
<xsl:apply-templates select="status"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>

<xsl:template match="reftaxonomy">
<xsl:variable name="myid" select="@refid"/>
<xsl:value-of select="/standards/taxonomy//node[@id=$myid]/@title"/><xsl:text>;&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="refgroup">
<xsl:text>{{Reference Group&#x0A;</xsl:text>
<xsl:text>|obligationtype=</xsl:text><xsl:apply-templates select="@obligation"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|lifecycletype=</xsl:text><xsl:apply-templates select="@lifecycle"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|description=</xsl:text><xsl:apply-templates select="description"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|standards=</xsl:text><xsl:apply-templates select="refstandard"/>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="refstandard">
<xsl:value-of select="@refid"/><xsl:text>;&#x0A;</xsl:text>
</xsl:template>


<!-- Handle profilespec reference -->

<xsl:template match="refprofilespec" mode="list-profilespec">
<xsl:variable name="myid" select="@refid"/>
<xsl:value-of select="/standards/records/profilespec[@id=$myid]/@title"/>
</xsl:template>


<!-- Handle subprofiles -->

<xsl:template match="refprofile" mode="list-profiles">
<xsl:variable name="myid" select="@refid"/>
<xsl:if test="/standards/records/profile[@id=$myid]"><xsl:value-of select="/standards/records/profile[@id=$myid]/@title"/><xsl:text>;&#x0A;</xsl:text></xsl:if>
</xsl:template>


<xsl:template match="refprofile" mode="list-serviceprofiles">
<xsl:variable name="myid" select="@refid"/>
<xsl:if test="/standards/records/serviceprofile[@id=$myid]"><xsl:value-of select="/standards/records/serviceprofile[@id=$myid]/@title"/><xsl:text>;&#x0A;</xsl:text></xsl:if>
</xsl:template>


<!-- Generate an Event list  -->

<xsl:template match="status"><xsl:text>|events=</xsl:text><xsl:apply-templates select="history/event"/></xsl:template>

<!-- Generate an Event element  -->

<xsl:template match="event">
<xsl:text>{{Change Event&#x0A;</xsl:text>
<xsl:text>|order=</xsl:text><xsl:number from="history" count="event"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|date=</xsl:text><xsl:value-of select="@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|flag=</xsl:text><xsl:value-of select="@flag"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|rfcp=</xsl:text><xsl:value-of select="@rfcp"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|version=</xsl:text><xsl:value-of select="@version"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:template>


<xsl:template match="description|applicability">
<xsl:text>&#x0A;</xsl:text>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="itemizedlist|orderedlist">
<xsl:text>&#x0A;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="listitem">
<xsl:text>* </xsl:text><xsl:apply-templates/>
</xsl:template>

<xsl:template match="para">
<xsl:apply-templates/>
<xsl:if test="following::node()"><xsl:text>&#x0A;</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="listitem/para">
<xsl:apply-templates/>
<xsl:if test="following::node()"><xsl:text>&#x0A;</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="text()"><xsl:value-of select="normalize-space()"/></xsl:template>

<xsl:template match="superscript"><sup><xsl:apply-templates/></sup></xsl:template>


<xsl:template match="emphasis"><xsl:text>'''</xsl:text><xsl:apply-templates/><xsl:text>'''</xsl:text></xsl:template>

<!-- Show elements without templates
     This template was created by Norman Walsh and is 'lifted' from the DocBook XSLT stylesheets.
-->

<xsl:template match="*">
  <xsl:message>
    <xsl:text>Element </xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text> in namespace '</xsl:text>
    <xsl:value-of select="namespace-uri(.)"/>
    <xsl:text>' encountered</xsl:text>
    <xsl:if test="parent::*">
      <xsl:text> in </xsl:text>
      <xsl:value-of select="name(parent::*)"/>
    </xsl:if>
    <xsl:text>, but no template matches.</xsl:text>
  </xsl:message>

  <span style="color: red">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>
  </span>
</xsl:template>


</xsl:stylesheet>
