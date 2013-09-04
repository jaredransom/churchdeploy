<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template name="nav-links">

  <div class="navbar-header">

    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
      <span class="sr-only">Toggle navigation</span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    <a class="logo" href="{$root}"><i class="icon-full-outline icon-md"></i></a>

  </div>
  <div class="collapse navbar-collapse navbar-ex1-collapse">
    <ul class="nav navbar-nav navbar-right">
      <xsl:for-each select="/data/tags-all-entries/entry[ not(parent/item) and not(hide-from-header = 'Yes') ]">
        <xsl:call-template name="subnav-entry-new" />
      </xsl:for-each>
      <xsl:if test="$cookie-username">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <i class="glyphicon glyphicon-wrench"></i>
          </a>
          <ul class="dropdown-menu">
            <li><a href="/symphony/" target="_blank">Symphony</a></li>
            <li><a href="?debug" target="_blank">Debug</a></li>
            <li><a href="?logs" target="_blank">Logs</a></li>
            <li><a href="?profile" target="_blank">Profile</a></li>
            <li><a href="{$root}/symphony/logout/">Logout</a></li>
          </ul>
        </li>
      </xsl:if>
    </ul>
  </div>

</xsl:template>


<xsl:template name="subnav-entry">
  <xsl:variable name="active-parent" select="/data/tags-all-entries/entry[ @id = $ds-tags-filtered.system-id ]/parent/item/@id" />
  <xsl:variable name="realID" select="@id" />
  <xsl:variable name="node" select="." />
  <li>
    <xsl:attribute name="class">
      <xsl:if test="/data/tags-all-entries/entry[@id]/parent[@items != 0]/item/@id = @id">
        <xsl:text>dropdown </xsl:text>
      </xsl:if>
      <xsl:text>entry</xsl:text>
      <xsl:if test="$pt1 = @id or $active-parent = @id or //tags-all-entries/entry[ @id = $active-parent ]/parent/item/@id = @id">
        <xsl:text> active</xsl:text>
      </xsl:if>
      <xsl:if test="/data/tags-all-entries/entry[@id]/parent[@items != 0]/item/@id = @id">
        <xsl:text> sub</xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="position() mod 2 = 0">
          <xsl:text> even</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> odd</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="position() = 1">
        <xsl:text> first</xsl:text>
      </xsl:if>
      <xsl:if test="position() &gt; 1 and position() &lt; last()">
        <xsl:text> middle</xsl:text>
      </xsl:if>
      <xsl:if test="position() = last()">
        <xsl:text> last</xsl:text>
      </xsl:if>
      <xsl:for-each select="tags/item">
        <xsl:text> category-</xsl:text>
        <xsl:value-of select="@id" />
      </xsl:for-each>
      <xsl:if test="file">
        <xsl:choose>
          <xsl:when test="file/@type = 'application/pdf'">
            <xsl:text> pdf</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> unknown</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:attribute>
    <a>
      <xsl:call-template name="url-tags" />
      <xsl:value-of select="tag" disable-output-escaping="yes" />
    </a>
    <xsl:if test="/data/tags-all-entries/entry[@id]/parent[@items != 0]/item/@id = @id">
      <ul class="dropdown-menu hidden-phone hidden-tablet" role="menu" aria-labelledby="dropdownMenu">
        <xsl:for-each select="/data/tags-all-entries/entry[parent/item/@id = $realID]">
          <li>
            <xsl:if test="/data/tags-all-entries/entry[@id]/parent[@items != 0]/item/@id = @id">
              <xsl:attribute name="class">
                <xsl:text>dropdown-submenu</xsl:text>
              </xsl:attribute>
            </xsl:if>
            <a>
              <xsl:call-template name="url-tags" />
              <xsl:value-of select="tag" disable-output-escaping="yes" />
            </a>
            <xsl:variable name="nestedID">
              <xsl:value-of select="@id" />
            </xsl:variable>
            <xsl:if test="/data/tags-all-entries/entry[@id]/parent[@items != 0]/item/@id = @id">
              <ul class="dropdown-menu">
                <xsl:for-each select="/data/tags-all-entries/entry[parent/item/@id = $nestedID]">
                  <li>
                    <a>
                      <xsl:call-template name="url-tags" />
                      <xsl:value-of select="tag" disable-output-escaping="yes" />
                    </a>
                  </li>
                </xsl:for-each>
              </ul>
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </li>
</xsl:template>


<xsl:template name="subnav-group">
  <xsl:param name="group" />
  <xsl:if test="count($group)">

    <div class="subnav visible-desktop">
      <ul class="nav nav-pills nav-justified">
        <xsl:for-each select="$group">
          <xsl:call-template name="subnav-entry" />
        </xsl:for-each>
      </ul>
    </div>

  </xsl:if>
</xsl:template>


<xsl:template name="subnav-entry-mobile">
  <xsl:variable name="active-parent" select="/data/tags-all-entries/entry[ @id = $pt1 ]/parent/item/@id" />
  <xsl:variable name="realID" select="@id" />
  <xsl:variable name="node" select="." />
  <h3 class="allcaps">
    <a>
      <xsl:call-template name="url-tags" />
      <xsl:value-of select="tag" disable-output-escaping="yes" />
    </a>
    <hr />
    <xsl:if test="/data/tags-all-entries/entry[@id]/parent[@items != 0]/item/@id = @id">
      <ul class="dropdown-menu">
        <xsl:for-each select="/data/tags-all-entries/entry[parent/item/@id = $realID]">
          <li>
            <a>
              <xsl:call-template name="url-tags" />
              <xsl:value-of select="tag" disable-output-escaping="yes" />
            </a>
          </li>
        </xsl:for-each>
        <hr />
      </ul>
    </xsl:if>
  </h3>
</xsl:template>


<xsl:template name="subnav-entry-new">
  <xsl:variable name="active-parent" select="/data/tags-all-entries/entry[ @id = $pt1 ]/parent/item/@id" />
  <xsl:variable name="realID" select="@id" />
  <xsl:variable name="node" select="." />
  <li>
    <xsl:if test="$pt1 = @id or $active-parent = @id or //tags-all-entries/entry[ @id = $active-parent ]/parent/item/@id = @id">
      <xsl:attribute name="class">
        <xsl:text>active</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <a>
      <xsl:call-template name="url-tags" />
      <xsl:value-of select="tag" disable-output-escaping="yes" />
    </a>
  </li>
</xsl:template>


<xsl:template name="subnav-mobile">
  <xsl:param name="group" />
  <xsl:if test="count($group)">
    <div class="btn-group">
      <button class="btn btn-large btn-block allcaps dropdown-toggle" data-toggle="dropdown">Navigate to... <span class="caret"></span></button>
      <ul class="dropdown-menu">
        <xsl:for-each select="$group">
          <xsl:call-template name="subnav-entry-mobile" />
        </xsl:for-each>
      </ul>
     </div>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>