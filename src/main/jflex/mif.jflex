/*
 * Copyright 2007 Andrew Bruno <aeb@qnot.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

package org.qnot.mif2xml;
import java.util.Stack;

%%

%{
  private Stack<Tag> tags = new Stack<Tag>();
  private StringBuffer data = new StringBuffer();
  private StringBuffer facet = new StringBuffer();
%}

%line
%char
%standalone
%class  MifLexer
%xstate DATA
%xstate STR
%xstate FACET

ID=[A-Za-z][A-Za-z0-9]*
TAG="<"{ID}" "
TAG_END=">"
NONNEWLINE=[^\r|\n|\r\n]
NEWLINE=[\r|\n|\r\n]
WHITE_SPACE_CHAR=[ \n\t]

%%

<YYINITIAL> { 
   {TAG}   {
        Tag tag = new Tag();
        tag.setName(yytext().substring(1, yytext().length()-1));
        tags.push(tag);
        tag.writeStart();
        data = new StringBuffer();
        yybegin(DATA);
    }

    {TAG_END}   {
        if(!tags.empty()) {
            Tag tag = (Tag)tags.pop();
            tag.writeEnd();
        }
    }

    ^"="[a-zA-Z][a-zA-Z0-9]*{NEWLINE} {
        String beginToken = yytext();
        if(!beginToken.startsWith("=EndInset")) {
            facet = new StringBuffer();
            facet.append(beginToken);
            yybegin(FACET);
        }
    }

    {WHITE_SPACE_CHAR}+   {  /* eat up whitespace */ }
    {NONNEWLINE}          {  /* eat up everything else  */ }
}

<DATA> {
    {NEWLINE}  {  
        if(!tags.empty()) {
            Tag tag = (Tag)tags.pop();
            tag.setValue(data.toString());
            tags.push(tag);
        }
        yybegin(YYINITIAL); 
    }
    "`"  {  yybegin(STR); }
    {TAG_END}  {  
        if(!tags.empty()) {
            Tag tag = (Tag)tags.pop();
            String value = tag.getValue();

            String dataStr = data.toString();
            if(dataStr != null && dataStr.length() > 0) {
                value = dataStr;
            }

            if(value != null) {
                value = value.replaceAll("^\\s+", "");
                value = value.replaceAll("\\s+$", "");
            }

            tag.setValue(value);
            tag.writeEnd();
        }
        yybegin(YYINITIAL); 
    }
    [^\n|\r|\r\n|`|>] {
        data.append(yytext());
    }
}

<STR> {
    "'"  {  
        if(!tags.empty()) {
            Tag tag = (Tag)tags.pop();
            if(tag.getValue() == null || tag.getValue().length() == 0) {
                tag.setValue("`'");
            }
            tags.push(tag);
        }
        yybegin(YYINITIAL); 
    }
    [^']*  {
        if(!tags.empty()) {
            Tag tag = (Tag)tags.pop();
            StringBuffer buf = new StringBuffer();
            buf.append("`");
            buf.append(yytext());
            buf.append("'");
            tag.setValue(buf.toString());
            tags.push(tag);
        }
    }
}

<FACET> {
    ^"=EndInset"{NEWLINE} {
        facet.append(yytext());
        Tag.writeFacet(facet.toString());
        yybegin(YYINITIAL);
    }

    .*{NEWLINE} {
        facet.append(yytext());
    }
}
