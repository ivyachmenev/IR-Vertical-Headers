set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,5027705623189871));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'ru'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,117);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/dynamic_action/irverticalheaders
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'DYNAMIC ACTION'
 ,p_name => 'IRVERTICALHEADERS'
 ,p_display_name => 'IR Vertical Headers'
 ,p_category => 'INIT'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'/*'||unistr('\000a')||
'  IR Vertical Headers Plug-in'||unistr('\000a')||
''||unistr('\000a')||
'  See plug-in documentation for more information.'||unistr('\000a')||
'*/'||unistr('\000a')||
''||unistr('\000a')||
'type t_substitution  is record ( name varchar2(255), value varchar2(32767) );'||unistr('\000a')||
'type t_substitutions is table of t_substitution index by pls_integer;'||unistr('\000a')||
''||unistr('\000a')||
'g_substitutions t_substitutions;'||unistr('\000a')||
'g_index         pls_integer;'||unistr('\000a')||
''||unistr('\000a')||
'function blob_to_clob (p_blob in  blob)'||unistr('\000a')||
'return clob'||unistr('\000a')||
'as'||unistr('\000a')||
'   l_clob clob;'||unistr('\000a')||
''||unistr('\000a')||
'   l_dest_offset number := 1'||
';'||unistr('\000a')||
'   l_src_offset number := 1;'||unistr('\000a')||
'   l_lang_ctx integer := dbms_lob.default_lang_ctx;'||unistr('\000a')||
'   l_warning integer;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  dbms_lob.createtemporary(l_clob, true, 1);'||unistr('\000a')||
''||unistr('\000a')||
'  dbms_lob.converttoclob( dest_lob => l_clob'||unistr('\000a')||
'                        , src_blob => p_blob'||unistr('\000a')||
'                        , amount => dbms_lob.lobmaxsize'||unistr('\000a')||
'                        , dest_offset => l_dest_offset'||unistr('\000a')||
'                        , src_offset => l_'||
'src_offset'||unistr('\000a')||
'                        , blob_csid => dbms_lob.default_csid'||unistr('\000a')||
'                        , lang_context => l_lang_ctx'||unistr('\000a')||
'                        , warning => l_warning );'||unistr('\000a')||
''||unistr('\000a')||
'  return l_clob;'||unistr('\000a')||
'end blob_to_clob;'||unistr('\000a')||
''||unistr('\000a')||
'procedure htp_print_clob( p_clob in clob )'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_length         number := nvl(dbms_lob.getlength(p_clob),0);'||unistr('\000a')||
'  l_chunk_length   number := dbms_lob.getChunkSize(p_clob);'||unistr('\000a')||
'  l_chunk_count   '||
' number := trunc(l_length/l_chunk_length) + sign(l_length/l_chunk_length - trunc(l_length/l_chunk_length));'||unistr('\000a')||
'begin'||unistr('\000a')||
'  owa_util.mime_header( ''text/css'', true );'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_length = 0) then'||unistr('\000a')||
'    '||unistr('\000a')||
'    return ;'||unistr('\000a')||
'  end if;  '||unistr('\000a')||
'          '||unistr('\000a')||
'  for i in 1 .. l_chunk_count loop'||unistr('\000a')||
'              '||unistr('\000a')||
'    htp.prn( dbms_lob.substr(p_clob, l_chunk_length, l_chunk_length * ( i - 1 ) + 1) );'||unistr('\000a')||
'  end loop;'||unistr('\000a')||
'end htp_print_clob;'||unistr('\000a')||
''||unistr('\000a')||
'func'||
'tion is_loaded(p_key in number)'||unistr('\000a')||
'return boolean'||unistr('\000a')||
'as'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if not apex_application.g_f50.exists(p_key) then'||unistr('\000a')||
''||unistr('\000a')||
'    apex_application.g_f50(p_key) := ''LOADED'';'||unistr('\000a')||
'    return false;'||unistr('\000a')||
''||unistr('\000a')||
'  elsif apex_application.g_f50(p_key) = ''LOADED'' then'||unistr('\000a')||
''||unistr('\000a')||
'    return true;'||unistr('\000a')||
'  else'||unistr('\000a')||
'    apex_application.g_f50(p_key) := ''LOADED'';'||unistr('\000a')||
'    return false;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'end is_loaded;'||unistr('\000a')||
''||unistr('\000a')||
'function replace_substitutions( p_clob in clob )'||unistr('\000a')||
'return '||
'clob'||unistr('\000a')||
'as'||unistr('\000a')||
'  p_clob_len              number := dbms_lob.getlength(p_clob);'||unistr('\000a')||
'  l_clob_res              clob := to_clob(null);'||unistr('\000a')||
''||unistr('\000a')||
'  type t_condition_res is table of boolean index by pls_integer;'||unistr('\000a')||
'  l_condition_res t_condition_res;'||unistr('\000a')||
''||unistr('\000a')||
'  l_pos                   number;'||unistr('\000a')||
''||unistr('\000a')||
'  l_content_start_pos     number;'||unistr('\000a')||
'  l_content_end_pos       number;'||unistr('\000a')||
'  l_content_text          varchar2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'  l_substitution_text    varch'||
'ar2(32767);'||unistr('\000a')||
'  l_substitution_type    varchar2(100);'||unistr('\000a')||
'begin'||unistr('\000a')||
'  l_pos := 1;'||unistr('\000a')||
'  l_content_start_pos := 0;'||unistr('\000a')||
'  l_content_end_pos := 0;'||unistr('\000a')||
'  while l_pos <= p_clob_len loop'||unistr('\000a')||
''||unistr('\000a')||
'    l_content_start_pos := instr( p_clob, ''[['', l_pos );'||unistr('\000a')||
'    l_content_end_pos := instr( p_clob, '']]'', greatest(l_pos,l_content_start_pos+2) ) + 1;'||unistr('\000a')||
'    '||unistr('\000a')||
'    if l_content_start_pos > 0 and l_content_start_pos < l_content_end_pos then'||unistr('\000a')||
'      '||unistr('\000a')||
''||
'      l_content_text := substr( p_clob, l_content_start_pos, l_content_end_pos - l_content_start_pos + 1 );'||unistr('\000a')||
'      '||unistr('\000a')||
'      -- determine substitution type'||unistr('\000a')||
'      case'||unistr('\000a')||
'        when ( substr(l_content_text,1,9) = ''[[@plsql:'' and substr(l_content_text,-2,2) = '']]'' ) then'||unistr('\000a')||
''||unistr('\000a')||
'          l_substitution_type := ''plsql'';'||unistr('\000a')||
'          l_substitution_text := substr(l_content_text,10,length(l_content_text)-11);'||unistr('\000a')||
'      '||
'  '||unistr('\000a')||
'        when ( substr(l_content_text,1,6) = ''[[@if:'' and substr(l_content_text,-2,2) = '']]'' ) then'||unistr('\000a')||
'        '||unistr('\000a')||
'          l_substitution_type := ''if'';'||unistr('\000a')||
'          l_substitution_text := substr(l_content_text,7,length(l_content_text)-8);'||unistr('\000a')||
'          '||unistr('\000a')||
'        when ( l_content_text = ''[[@end-if]]'' ) then'||unistr('\000a')||
''||unistr('\000a')||
'          l_substitution_type := ''end_if'';'||unistr('\000a')||
'          l_substitution_text := null;'||unistr('\000a')||
'        else '||unistr('\000a')||
'     '||
'     l_substitution_type := ''text_with_substitution_strings'';'||unistr('\000a')||
'          l_substitution_text := substr(l_content_text,3,length(l_content_text)-4);'||unistr('\000a')||
'      end case;'||unistr('\000a')||
''||unistr('\000a')||
'      -- replace substitutions'||unistr('\000a')||
'      for i in 1..g_substitutions.count loop'||unistr('\000a')||
''||unistr('\000a')||
'        l_substitution_text := replace( l_substitution_text, ''#''||g_substitutions(i).name||''#'', g_substitutions(i).value );'||unistr('\000a')||
'      end loop; '||unistr('\000a')||
'    '||unistr('\000a')||
'      -- proce'||
'ss pl/sql'||unistr('\000a')||
'      if ( l_substitution_type = ''plsql'' ) then'||unistr('\000a')||
'    '||unistr('\000a')||
'        execute immediate '||unistr('\000a')||
'        ''begin :1 := '' || l_substitution_text || ''; end;'''||unistr('\000a')||
'        using out l_substitution_text;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'      '||unistr('\000a')||
'      -- process if'||unistr('\000a')||
'      if ( l_substitution_type = ''if'' ) then'||unistr('\000a')||
'      '||unistr('\000a')||
'        -- positive'||unistr('\000a')||
'        if l_substitution_text = ''1'' then'||unistr('\000a')||
'          '||unistr('\000a')||
'          l_substitution_text := null;'||unistr('\000a')||
''||unistr('\000a')||
'       '||
'   if l_condition_res.count > 0  then'||unistr('\000a')||
''||unistr('\000a')||
'            if l_condition_res(l_condition_res.count) = false then'||unistr('\000a')||
''||unistr('\000a')||
'              l_condition_res(l_condition_res.count+1) := false;'||unistr('\000a')||
'            else'||unistr('\000a')||
'              l_condition_res(l_condition_res.count+1) := true;'||unistr('\000a')||
'            end if;'||unistr('\000a')||
'          else'||unistr('\000a')||
'            l_condition_res(l_condition_res.count+1) := true;'||unistr('\000a')||
'          end if;'||unistr('\000a')||
'          '||unistr('\000a')||
'        -- negative'||unistr('\000a')||
' '||
'       elsif l_substitution_text = ''0'' then'||unistr('\000a')||
'        '||unistr('\000a')||
'          l_substitution_text := null;'||unistr('\000a')||
'          l_condition_res(l_condition_res.count+1) := false;'||unistr('\000a')||
'        end if;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'      '||unistr('\000a')||
'      -- compute result'||unistr('\000a')||
'      case'||unistr('\000a')||
'        when ( l_condition_res.count = 0                                 '||unistr('\000a')||
'            or l_condition_res.count = 1 and l_substitution_type = ''if'' ) then '||unistr('\000a')||
'            '||unistr('\000a')||
'        '||
'  l_clob_res := l_clob_res || substr(p_clob,l_pos,l_content_start_pos-l_pos) || to_clob(l_substitution_text);'||unistr('\000a')||
'            '||unistr('\000a')||
'        when l_condition_res.count >= 1 and l_substitution_type != ''if'' then'||unistr('\000a')||
'      '||unistr('\000a')||
'          if l_condition_res(l_condition_res.count) then'||unistr('\000a')||
'            '||unistr('\000a')||
'            l_clob_res := l_clob_res || substr(p_clob,l_pos,l_content_start_pos-l_pos) || to_clob(l_substitution_text);'||unistr('\000a')||
'   '||
'       else'||unistr('\000a')||
'            null;'||unistr('\000a')||
'          end if;'||unistr('\000a')||
'          '||unistr('\000a')||
'        when l_condition_res.count > 1 and l_substitution_type = ''if'' then'||unistr('\000a')||
'          '||unistr('\000a')||
'          if l_condition_res(l_condition_res.count-1) then'||unistr('\000a')||
'            '||unistr('\000a')||
'            l_clob_res := l_clob_res || substr(p_clob,l_pos,l_content_start_pos-l_pos);'||unistr('\000a')||
'          else'||unistr('\000a')||
'            null;'||unistr('\000a')||
'          end if;'||unistr('\000a')||
'      end case;'||unistr('\000a')||
'      '||unistr('\000a')||
'      -- process end '||
'if'||unistr('\000a')||
'      if ( l_substitution_type = ''end_if'' ) then'||unistr('\000a')||
'        '||unistr('\000a')||
'        l_condition_res.delete(l_condition_res.count);'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'        '||unistr('\000a')||
'      l_pos := l_content_end_pos+1;'||unistr('\000a')||
'      '||unistr('\000a')||
'    -- no substitution'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_clob_res := l_clob_res || substr(p_clob,l_pos);'||unistr('\000a')||
'      l_pos := p_clob_len+1;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end loop;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_clob_res;'||unistr('\000a')||
'end replace_substitutions;'||unistr('\000a')||
''||unistr('\000a')||
'procedure populate_substitu'||
'tions('||unistr('\000a')||
'    p_dynamic_action in apex_plugin.t_dynamic_action,'||unistr('\000a')||
'    p_plugin         in apex_plugin.t_plugin )'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_file_name             varchar2(4000) := apex_application.g_x01;'||unistr('\000a')||
'  l_load                  varchar2(4000) := apex_application.g_x02;'||unistr('\000a')||
''||unistr('\000a')||
'  l_plugin_name           varchar2(255) := p_plugin.name;'||unistr('\000a')||
''||unistr('\000a')||
'  l_app_id         varchar2(255) := :app_id;'||unistr('\000a')||
'  l_workspace_name varchar2(255) := apex_util.fi'||
'nd_workspace( apex_custom_auth.get_security_group_id );'||unistr('\000a')||
''||unistr('\000a')||
'  l_user_agent            varchar2(4000) := upper(owa_util.get_cgi_env(''HTTP_USER_AGENT''));'||unistr('\000a')||
'  l_column_list           varchar2(32767) := p_dynamic_action.attribute_01;'||unistr('\000a')||
'  l_column_ids            varchar2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'  l_sel_th                varchar2(32767);'||unistr('\000a')||
'  l_sel_td                varchar2(32767);'||unistr('\000a')||
'  l_sel_th_div            varchar2(32767);'||unistr('\000a')||
'  '||
'l_sel_th_a              varchar2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'  l_sel_fixed_th          varchar2(32767);'||unistr('\000a')||
'  l_sel_fixed_th_a        varchar2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'  l_sel_controlbreak_th      varchar2(32767);'||unistr('\000a')||
'  l_sel_controlbreak_th_span varchar2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'  l_sel_pivot_row_th      varchar2(32767);'||unistr('\000a')||
'  l_sel_pivot_row_th_a    varchar2(32767);'||unistr('\000a')||
''||unistr('\000a')||
'  l_width                 number := p_dynamic_action.attribute_02;'||unistr('\000a')||
'  l_height              '||
'  number := p_dynamic_action.attribute_03;'||unistr('\000a')||
''||unistr('\000a')||
'  l_border_width_summary  number := 1;'||unistr('\000a')||
'  l_border_height_summary number := 1;'||unistr('\000a')||
''||unistr('\000a')||
'  l_left_padding          number := p_dynamic_action.attribute_04;'||unistr('\000a')||
'  l_right_padding         number := p_dynamic_action.attribute_05;'||unistr('\000a')||
'  l_top_padding           number := p_dynamic_action.attribute_06;'||unistr('\000a')||
'  l_bottom_padding        number := p_dynamic_action.attribute_07;'||unistr('\000a')||
''||unistr('\000a')||
'  l_td_l'||
'eft_padding       number := p_dynamic_action.attribute_11;'||unistr('\000a')||
'  l_td_right_padding      number := p_dynamic_action.attribute_12;'||unistr('\000a')||
''||unistr('\000a')||
'  l_line_height           number := p_dynamic_action.attribute_08;'||unistr('\000a')||
'  l_lines                 number := p_dynamic_action.attribute_13;'||unistr('\000a')||
''||unistr('\000a')||
'  l_vertical_position     varchar2(10) := p_dynamic_action.attribute_09;'||unistr('\000a')||
'  l_horizontal_position   varchar2(10) := p_dynamic_action.attrib'||
'ute_10;'||unistr('\000a')||
''||unistr('\000a')||
'  l_align                 varchar2(10);'||unistr('\000a')||
'  l_v_align               varchar2(10);'||unistr('\000a')||
''||unistr('\000a')||
'  l_release               varchar2(40);'||unistr('\000a')||
'  l_region_id             number;'||unistr('\000a')||
'  l_region_static_id      varchar2(255);'||unistr('\000a')||
''||unistr('\000a')||
'  l_sel_region            varchar2(255);'||unistr('\000a')||
''||unistr('\000a')||
'  l_include_region_id     boolean := true;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  select version_no into l_release'||unistr('\000a')||
'  from apex_release t;'||unistr('\000a')||
''||unistr('\000a')||
'  select a.affected_region_id'||unistr('\000a')||
'       , r.sta'||
'tic_id'||unistr('\000a')||
'    into l_region_id, l_region_static_id'||unistr('\000a')||
'  from apex_application_page_da_acts a'||unistr('\000a')||
'     , apex_application_page_regions r'||unistr('\000a')||
'  where a.action_id = p_dynamic_action.id'||unistr('\000a')||
'    and a.affected_region_id = r.region_id;'||unistr('\000a')||
''||unistr('\000a')||
'  l_sel_region := ''#'' || nvl(l_region_static_id, ''R'' || to_char(l_region_id));'||unistr('\000a')||
'  '||unistr('\000a')||
'  if l_release like ''4.2.%'' then'||unistr('\000a')||
''||unistr('\000a')||
'    -- th selector, format: th#COLUMN_NAME1, th#COLUMN_NAME2, ...'||unistr('\000a')||
'    l'||
'_sel_th := ''th#'' || replace(l_column_list,'','','',th#'');'||unistr('\000a')||
''||unistr('\000a')||
'    -- td selector, format: td[headers="COLUMN_NAME1"], td[headers="COLUMN_NAME2"], ..'||unistr('\000a')||
'    l_sel_td := ''.apexir_WORKSHEET_DATA td[headers="'' || replace(l_column_list,'','',''"],td[headers="'') || ''"]'';'||unistr('\000a')||
''||unistr('\000a')||
'    -- th div selector, format: th#COLUMN_NAME1 > div, th#COLUMN_NAME2 > div, ...'||unistr('\000a')||
'    l_sel_th_div := ''th#'' || replace(l_column_list,'','','' > div,'||
'th#'') || '' > div'';'||unistr('\000a')||
''||unistr('\000a')||
'    -- th a selector, format: th#COLUMN_NAME1 > a, th#COLUMN_NAME2 > a, ...'||unistr('\000a')||
'    l_sel_th_a := ''th#'' || replace(l_column_list,'','','' > a,th#'') || '' > a'';'||unistr('\000a')||
''||unistr('\000a')||
'  else -- 5.0+'||unistr('\000a')||
''||unistr('\000a')||
'    select listagg(column_id,'','') within group (order by column_alias)'||unistr('\000a')||
'      into l_column_ids'||unistr('\000a')||
'    from APEX_APPLICATION_PAGE_IR_COL t'||unistr('\000a')||
'    where t.page_id = :app_page_id'||unistr('\000a')||
'      and t.application_id = :app_id'||unistr('\000a')||
'    '||
'  and instr( '','' || l_column_list  || '','', '','' || column_alias || '','' ) > 0;'||unistr('\000a')||
''||unistr('\000a')||
'    if l_include_region_id then'||unistr('\000a')||
''||unistr('\000a')||
'      l_sel_th := l_sel_region || '' th#C'' || replace(l_column_ids,'','','','' || l_sel_region || '' th#C'');'||unistr('\000a')||
'      l_sel_td := l_sel_region || '' td[headers="C'' || replace(l_column_ids,'','',''"],'' || l_sel_region || '' td[headers="C'') || ''"]'';'||unistr('\000a')||
'      l_sel_th_div := l_sel_region || '' th#C'' || replac'||
'e(l_column_ids,'','','' > div,'' || l_sel_region || '' th#C'') || '' > div'';'||unistr('\000a')||
'      l_sel_th_a := l_sel_region || '' th#C'' || replace(l_column_ids,'','','' > a,'' || l_sel_region || '' th#C'') || '' > a'';'||unistr('\000a')||
''||unistr('\000a')||
'      l_sel_fixed_th := l_sel_region || '' .t-fht-tbody th.a-IRR-header[fh-data-column="'' || replace(l_column_ids,'','',''"],'' || l_sel_region || '' .t-fht-tbody th.a-IRR-header[fh-data-column="'') || ''"]'';'||unistr('\000a')||
'      l_s'||
'el_fixed_th_a := l_sel_region || '' .t-fht-tbody a[data-column="'' || replace(l_column_ids,'','',''"],'' || l_sel_region || '' .t-fht-tbody a[data-column="'') || ''"]'';'||unistr('\000a')||
' '||unistr('\000a')||
'      l_sel_controlbreak_th := l_sel_region || '' th.a-IRR-header[cb-data-column="'' || replace(l_column_ids,'','',''"],'' || l_sel_region || '' th.a-IRR-header[cb-data-column="'') || ''"]'';'||unistr('\000a')||
'      l_sel_controlbreak_th_span := l_sel_region || '' th'||
'.a-IRR-header[cb-data-column="'' || replace(l_column_ids,'','',''"] > span,'' || l_sel_region || '' th.a-IRR-header[cb-data-column="'') || ''"] > span'';'||unistr('\000a')||
''||unistr('\000a')||
'      l_sel_pivot_row_th   := l_sel_region || '' th.a-IRR-header[pr-data-column="'' || replace(l_column_ids,'','',''"],'' || l_sel_region || '' th.a-IRR-header[pr-data-column="'') || ''"]'';'||unistr('\000a')||
'      l_sel_pivot_row_th_a := l_sel_region || '' th.a-IRR-header[pr-data-c'||
'olumn="'' || replace(l_column_ids,'','',''"] > a,'' || l_sel_region || '' th.a-IRR-header[pr-data-column="'') || ''"] > a'';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_sel_th := ''th#C'' || replace(l_column_ids,'','','',th#C'');'||unistr('\000a')||
'      l_sel_td := ''.a-IRR-table td[headers="C'' || replace(l_column_ids,'','',''"],td[headers="C'') || ''"]'';'||unistr('\000a')||
'      l_sel_th_div := ''th#C'' || replace(l_column_ids,'','','' > div,th#C'') || '' > div'';'||unistr('\000a')||
'      l_sel_th_a := ''th'||
'#C'' || replace(l_column_ids,'','','' > a,th#C'') || '' > a'';'||unistr('\000a')||
''||unistr('\000a')||
'      l_sel_fixed_th := ''.t-fht-tbody th.a-IRR-header[fh-data-column="'' || replace(l_column_ids,'','',''"],.t-fht-tbody th.a-IRR-header[fh-data-column="'') || ''"]'';'||unistr('\000a')||
'      l_sel_fixed_th_a := ''.t-fht-tbody a[data-column="'' || replace(l_column_ids,'','',''"],.t-fht-tbody a[data-column="'') || ''"]'';'||unistr('\000a')||
' '||unistr('\000a')||
'      l_sel_controlbreak_th   := ''th.a-IRR-header[c'||
'b-data-column="'' || replace(l_column_ids,'','',''"],th.a-IRR-header[cb-data-column="'') || ''"]'';'||unistr('\000a')||
'      l_sel_controlbreak_th_span := ''th.a-IRR-header[cb-data-column="'' || replace(l_column_ids,'','',''"] > span,th.a-IRR-header[cb-data-column="'') || ''"] > span'';'||unistr('\000a')||
''||unistr('\000a')||
'      l_sel_pivot_row_th   := ''th.a-IRR-header[pr-data-column="'' || replace(l_column_ids,'','',''"],th.a-IRR-header[pr-data-column="'') || ''"]'';'||unistr('\000a')||
'    '||
'  l_sel_pivot_row_th_a := ''th.a-IRR-header[pr-data-column="'' || replace(l_column_ids,'','',''"] > a,th.a-IRR-header[pr-data-column="'') || ''"] > a'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''HEIGHT'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_height;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''WIDTH'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_w'||
'idth;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''BORDER_HEIGHT_SUMMMARY'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_border_height_summary;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''BORDER_WIDTH_SUMMMARY'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_border_width_summary;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_inde'||
'x).name  := ''BOTTOM_PADDING'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_bottom_padding;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''TOP_PADDING'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_top_padding;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''RIGHT_PADDING'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_right_padding;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitu'||
'tions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''LEFT_PADDING'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_left_padding;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''REGION_ID'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_region;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''TH_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_th;'||unistr('\000a')||
''||unistr('\000a')||
'  g_i'||
'ndex := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''TD_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_td;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''TH_DIV_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_th_div;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''TH_A_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_t'||
'h_a;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''FIXED_TH_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_fixed_th;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''FIXED_TH_A_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_fixed_th_a;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''CONTROLBREAK_TH_LIST'';'||
''||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_controlbreak_th;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''CONTROLBREAK_TH_SPAN_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_controlbreak_th_span;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''PIVOT_ROW_TH_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_pivot_row_th;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_su'||
'bstitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''PIVOT_ROW_TH_A_LIST'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_sel_pivot_row_th_a;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''LINE_HEIGHT'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_line_height;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''LINES'';'||unistr('\000a')||
'  g_substitutions(g_index).value :'||
'= l_lines;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''ALIGN'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_align;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''VERTICAL_ALIGN'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_v_align;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''VERTICAL_POSITION'';'||unistr('\000a')||
'  g_substitutio'||
'ns(g_index).value := l_vertical_position;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''HORIZONTAL_POSITION'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_horizontal_position;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''LEFT_PADDING_FOR_TABLE_CELL'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_td_left_padding;'||unistr('\000a')||
''||unistr('\000a')||
'  g_index := g_substitutions.last'||
' + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''RIGHT_PADDING_FOR_TABLE_CELL'';'||unistr('\000a')||
'  g_substitutions(g_index).value := l_td_right_padding;'||unistr('\000a')||
''||unistr('\000a')||
'  -- horizontal positions'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_HORIZONTAL_POSITION_LEFT'';'||unistr('\000a')||
'  if l_horizontal_position = ''left'' then'||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  '||
'end if;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_HORIZONTAL_POSITION_CENTER'';'||unistr('\000a')||
'  if l_horizontal_position = ''center'' then'||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_HORIZONTAL_POSITION_RIGHT'';'||unistr('\000a')||
'  if l_horizontal_positi'||
'on = ''right'' then'||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'  '||unistr('\000a')||
'  -- vertical positions'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_VERTICAL_POSITION_TOP'';'||unistr('\000a')||
'  if l_vertical_position = ''top'' then'||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g'||
'_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_VERTICAL_POSITION_MIDDLE'';'||unistr('\000a')||
'  if l_vertical_position = ''middle'' then'||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'  '||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_VERTICAL_POSITION_BOTTOM'';'||unistr('\000a')||
'  if l_vertical_position = ''bottom'' then'||unistr('\000a')||
'  '||
'  g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'  '||unistr('\000a')||
'  -- line height is not null'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_LINE_HEIGHT_NOT_NULL'';'||unistr('\000a')||
'  '||unistr('\000a')||
'  if l_line_height is not null then'||unistr('\000a')||
'    '||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  -- for ie8 an'||
'd lower '||unistr('\000a')||
'  -- user agent settings info: http://www.useragentstring.com/pages/Internet%20Explorer/'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_LT_IE_9'';'||unistr('\000a')||
'  '||unistr('\000a')||
'  if instr(l_user_agent, ''MSIE 6'') > 0'||unistr('\000a')||
'  or instr(l_user_agent, ''MSIE 7'') > 0'||unistr('\000a')||
'  or instr(l_user_agent, ''MSIE 8'') > 0 then'||unistr('\000a')||
'  '||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value'||
' := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  -- for ie9 and lower '||unistr('\000a')||
'  -- user agent settings info: http://www.useragentstring.com/pages/Internet%20Explorer/'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_LT_IE_10'';'||unistr('\000a')||
'  '||unistr('\000a')||
'  if instr(l_user_agent, ''MSIE 6'') > 0'||unistr('\000a')||
'  or instr(l_user_agent, ''MSIE 7'') > 0'||unistr('\000a')||
'  or instr(l_user_agent, ''MSIE 8'') > 0'||unistr('\000a')||
'  or instr(l_user_agent, ''MSIE 9'') > 0 then'||unistr('\000a')||
'  '||unistr('\000a')||
'    g_subs'||
'titutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  -- not ie'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_NOT_IE'';'||unistr('\000a')||
'  '||unistr('\000a')||
'  if instr(l_user_agent, ''MSIE'') = 0 then'||unistr('\000a')||
'  '||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  -- first'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  '||
'g_substitutions(g_index).name  := ''IS_NOT_LOADED'';'||unistr('\000a')||
'  '||unistr('\000a')||
'  if l_load = ''0'' then'||unistr('\000a')||
'  '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  -- apex 4.2'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_APEX_4_2'';'||unistr('\000a')||
'  '||unistr('\000a')||
'  if l_release like ''4.2.%'' then'||unistr('\000a')||
'  '||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g'||
'_index).value := ''0'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  -- apex 5.0+'||unistr('\000a')||
'  g_index := g_substitutions.last + 1;'||unistr('\000a')||
'  g_substitutions(g_index).name  := ''IS_NOT_APEX_4_2'';'||unistr('\000a')||
'  '||unistr('\000a')||
'  if l_release like ''4.2.%'' then'||unistr('\000a')||
'  '||unistr('\000a')||
'    g_substitutions(g_index).value := ''0'';'||unistr('\000a')||
'  else '||unistr('\000a')||
'    g_substitutions(g_index).value := ''1'';'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'end populate_substitutions;'||unistr('\000a')||
''||unistr('\000a')||
'function get_substitution( p_name in varchar2 )'||unistr('\000a')||
'return varchar2'||unistr('\000a')||
'as'||unistr('\000a')||
'begin'||unistr('\000a')||
'  for i in 1.'||
'.g_substitutions.count loop'||unistr('\000a')||
''||unistr('\000a')||
'    if g_substitutions(i).name = p_name then'||unistr('\000a')||
''||unistr('\000a')||
'      return g_substitutions(i).value;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  end loop; '||unistr('\000a')||
''||unistr('\000a')||
'  return to_char(null);'||unistr('\000a')||
'end;'||unistr('\000a')||
''||unistr('\000a')||
'function irvh_ajax ('||unistr('\000a')||
'    p_dynamic_action in apex_plugin.t_dynamic_action,'||unistr('\000a')||
'    p_plugin         in apex_plugin.t_plugin )'||unistr('\000a')||
'return apex_plugin.t_dynamic_action_ajax_result'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_file_name      varchar2(4000) := apex_application.g_x'||
'01;'||unistr('\000a')||
'  l_load           varchar2(4000) := apex_application.g_x02;'||unistr('\000a')||
''||unistr('\000a')||
'  l_plugin_name    varchar2(255) := p_plugin.name;'||unistr('\000a')||
''||unistr('\000a')||
'  l_app_id         varchar2(255) := :app_id;'||unistr('\000a')||
'  l_workspace_name varchar2(255) := apex_util.find_workspace( apex_custom_auth.get_security_group_id );'||unistr('\000a')||
'  l_file_blob      blob;'||unistr('\000a')||
'  l_file_charset   varchar2(255);'||unistr('\000a')||
'  l_file_clob      clob;'||unistr('\000a')||
''||unistr('\000a')||
'  l_result         apex_plugin.t_dynamic_action_'||
'ajax_result;'||unistr('\000a')||
'begin '||unistr('\000a')||
'  -- get css file'||unistr('\000a')||
'  select t.file_content, t.file_charset'||unistr('\000a')||
'    into l_file_blob, l_file_charset'||unistr('\000a')||
'  from apex_appl_plugin_files t'||unistr('\000a')||
'  where t.workspace = l_workspace_name'||unistr('\000a')||
'    and t.application_id = l_app_id'||unistr('\000a')||
'  '||unistr('\000a')||
'    and t.plugin_name = l_plugin_name'||unistr('\000a')||
'    and t.file_name = l_file_name'||unistr('\000a')||
'  ;'||unistr('\000a')||
''||unistr('\000a')||
'  -- do substitutions  '||unistr('\000a')||
'  populate_substitutions( p_dynamic_action, p_plugin );'||unistr('\000a')||
'  l_file_clob := b'||
'lob_to_clob( l_file_blob );'||unistr('\000a')||
'  l_file_clob := replace_substitutions( l_file_clob );'||unistr('\000a')||
''||unistr('\000a')||
'  htp_print_clob( l_file_clob );'||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end irvh_ajax;'||unistr('\000a')||
''||unistr('\000a')||
'function irvh_render ('||unistr('\000a')||
'    p_dynamic_action in apex_plugin.t_dynamic_action,'||unistr('\000a')||
'    p_plugin         in apex_plugin.t_plugin )'||unistr('\000a')||
'return apex_plugin.t_dynamic_action_render_result'||unistr('\000a')||
'is'||unistr('\000a')||
'  l_column_list            varchar2(32767) := p_dynamic_action.attribut'||
'e_01;      '||unistr('\000a')||
'  l_plugin_name            varchar2(255) := p_plugin.name;'||unistr('\000a')||
''||unistr('\000a')||
'  l_result                 apex_plugin.t_dynamic_action_render_result;'||unistr('\000a')||
''||unistr('\000a')||
'  C_IS_LOADED_IND          CONSTANT PLS_INTEGER:= 1;'||unistr('\000a')||
'begin'||unistr('\000a')||
'    -- Print debug information'||unistr('\000a')||
'    if apex_application.g_debug then'||unistr('\000a')||
'        apex_plugin_util.debug_dynamic_action ('||unistr('\000a')||
'            p_plugin         => p_plugin,'||unistr('\000a')||
'            p_dynamic_action => p_dynam'||
'ic_action );'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    -- add javascript'||unistr('\000a')||
'    apex_javascript.add_library ( p_name => ''irvh'''||unistr('\000a')||
'                                , p_directory => p_plugin.file_prefix );'||unistr('\000a')||
''||unistr('\000a')||
'    -- add the css'||unistr('\000a')||
''||unistr('\000a')||
'    -- each file will be added once with the given p_name, x02 is not set when the css is already loaded in another plug-in instance'||unistr('\000a')||
'    if not(is_loaded( C_IS_LOADED_IND )) then'||unistr('\000a')||
''||unistr('\000a')||
'      apex_css.add_file ( p'||
'_name => ''wwv_flow.show?p_flow_id=&APP_ID.&p_flow_step_id=&APP_PAGE_ID.&p_instance=&SESSION.&p_debug=&DEBUG.&p_request=PLUGIN='' || apex_plugin.get_ajax_identifier || ''&x01='' || ''irvh_dynamic.css'' || ''&x02=1'''||unistr('\000a')||
'                        , p_skip_extension => true'||unistr('\000a')||
'                        , p_directory => null );'||unistr('\000a')||
'    else'||unistr('\000a')||
'      apex_css.add_file ( p_name => ''wwv_flow.show?p_flow_id=&APP_ID.&p_flow_step_i'||
'd=&APP_PAGE_ID.&p_instance=&SESSION.&p_debug=&DEBUG.&p_request=PLUGIN='' || apex_plugin.get_ajax_identifier || ''&x01='' || ''irvh_dynamic.css'' || ''&x02=0'''||unistr('\000a')||
'                        , p_skip_extension => true'||unistr('\000a')||
'                        , p_directory => null );'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    -- Register the function and the used attributes with the dynamic action framework'||unistr('\000a')||
'    l_result.javascript_function := ''irvh_init'';'||
''||unistr('\000a')||
'    '||unistr('\000a')||
'    populate_substitutions( p_dynamic_action, p_plugin );'||unistr('\000a')||
'    '||unistr('\000a')||
'    l_result.attribute_01 := get_substitution(''IS_APEX_4_2'');'||unistr('\000a')||
'    l_result.attribute_02 := get_substitution(''REGION_ID'');'||unistr('\000a')||
''||unistr('\000a')||
'    return l_result;'||unistr('\000a')||
'end irvh_render;'
 ,p_render_function => 'irvh_render'
 ,p_ajax_function => 'irvh_ajax'
 ,p_standard_attributes => 'REGION:REQUIRED:ONLOAD'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	IR Vertical Headers.</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	<span class="short_text" id="result_box" lang="en"><span class="hps alt-edited">The plug-in allows you to position IR headers vertically. </span></span>This is free and <span class="short_text" id="result_box" lang="en"><span class="hps">easy</span> <span class="hps alt-edited">in adjustment extension to Interactive Report.</span></span></p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.0.1'
 ,p_about_url => 'http://apex-plugin.com/oracle-apex-plugins/dynamic-action-plugin/ir-vertical-headers_433.html'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18460519938394578 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Comma Separated Column List'
 ,p_attribute_type => 'TEXTAREA'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_help_text => 'Enter the Column List you want to be Vertical.<br><br>'||unistr('\000a')||
''||unistr('\000a')||
'Example: <b>NUM,EMPLOYER_NAME,COMPANY_NAME</b>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18464403538067638 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Width (px)'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '20'
 ,p_display_length => 70
 ,p_is_translatable => false
 ,p_help_text => 'The width of the vertical headers.<br>'||unistr('\000a')||
'The value should be large enough to fit the text.<br><br>'||unistr('\000a')||
''||unistr('\000a')||
'Default: 20 (px)'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18464804173082549 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Height (px)'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '90'
 ,p_is_translatable => false
 ,p_help_text => 'The height of the vertical headers.<br>'||unistr('\000a')||
'The value should be large enough to fit the text.<br><br>'||unistr('\000a')||
''||unistr('\000a')||
'Default: 90 (px)'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18557735892445097 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 70
 ,p_prompt => 'Left Padding (px)'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '0'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18607114877815618 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Right Padding (px)'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '0'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18560017123727329 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 40
 ,p_prompt => 'Top Padding (px)'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '0'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18560735873733788 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 60
 ,p_prompt => 'Bottom Padding (px)'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '0'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18571835622675355 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Line Height'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '13'
 ,p_is_translatable => false
 ,p_help_text => 'Line Height Default: 13 (px)<br><br> '||unistr('\000a')||
''||unistr('\000a')||
'Defaults for non-vertical columns:<br><br> '||unistr('\000a')||
''||unistr('\000a')||
'font: bold 13px/16px Arial,sans-serif;<br>'||unistr('\000a')||
'(font-size: 13px; line-height: 16px;)'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 18614529583553336 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 15
 ,p_prompt => 'Vertical Position'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'middle'
 ,p_is_translatable => false
 ,p_help_text => 'Vertical Position controls the position and alignment of the text.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 18615605645564401 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 18614529583553336 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Top'
 ,p_return_value => 'top'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 18616003704565325 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 18614529583553336 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Middle'
 ,p_return_value => 'middle'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 18616433668566616 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 18614529583553336 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Bottom'
 ,p_return_value => 'bottom'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 22087120675015334 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 10
 ,p_display_sequence => 12
 ,p_prompt => 'Horizontal Position'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'center'
 ,p_is_translatable => false
 ,p_help_text => 'For this feature to work properly the width of the header should be large enough to fit the text in each row. If this is the case you can reduce the <b>Padding For Table Cell</b>. You also can turn this feature to left and adjust position with <b>Left Padding (px)</b> attribute.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 22087818518016297 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 22087120675015334 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Left'
 ,p_return_value => 'left'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 22088217009017023 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 22087120675015334 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Center'
 ,p_return_value => 'center'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 22088613774018480 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 22087120675015334 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Right'
 ,p_return_value => 'right'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 22113721290701740 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 11
 ,p_display_sequence => 110
 ,p_prompt => 'Left Padding for Table Cell (px)'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '8'
 ,p_is_translatable => false
 ,p_help_text => 'You can not set the width of headers less then the width of content of the table cells. However you can set table cell padding to smaller values.<br><br>'||unistr('\000a')||
''||unistr('\000a')||
'Default: 8 (px)'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 22116534865710644 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 12
 ,p_display_sequence => 120
 ,p_prompt => 'Right Padding for Table Cell (px)'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '8'
 ,p_is_translatable => false
 ,p_help_text => 'You can not set the width of headers less then the width of content of the table cells. However you can set table cell padding to smaller values.<br><br>'||unistr('\000a')||
''||unistr('\000a')||
'Default: 8 (px)'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 22127521225701364 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 13
 ,p_display_sequence => 75
 ,p_prompt => 'Lines'
 ,p_attribute_type => 'NUMBER'
 ,p_is_required => true
 ,p_default_value => '1'
 ,p_is_translatable => false
 ,p_help_text => 'The number of lines in header. You can enter several lines in header using <br /> tag.'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '0D0A2F2F2073657420696E666F726D6174696F6E20746861742074686520706C75672D696E20697320757365640D0A77696E646F772E785F706C7567696E5F69727668203D20747275653B0D0A0D0A2F2F20696E697469616C697A6174696F6E0D0A2F2F';
wwv_flow_api.g_varchar2_table(2) := '206174747269627574655F3031202D2049535F415045585F345F320D0A2F2F206174747269627574655F3032202D20524547494F4E5F49440D0A66756E6374696F6E20697276685F696E6974202829207B0D0A0D0A20202020766172206C497341706578';
wwv_flow_api.g_varchar2_table(3) := '5F345F32203D20746869732E616374696F6E2E61747472696275746530313B0D0A20202020766172206C526567696F6E49642020203D20746869732E616374696F6E2E61747472696275746530323B0D0A090D0A20202020617065782E6A517565727928';
wwv_flow_api.g_varchar2_table(4) := '6C526567696F6E4964292E6C697665282261706578616674657272656672657368222C2066756E6374696F6E2829207B0D0A09090D0A09092F2F207A2D696E6465780D0A090969662028206C4973417065785F345F32203D3D202731272029207B0D0A0D';
wwv_flow_api.g_varchar2_table(5) := '0A090909617065782E6A517565727928222E6170657869725F574F524B53484545545F4441544120746822292E656163682866756E6374696F6E2870496E646578297B0D0A0D0A09090909617065782E6A51756572792874686973292E63737328227A2D';
wwv_flow_api.g_varchar2_table(6) := '696E646578222C202F2A313030302D2A2F70496E64657820293B0D0A0909097D293B0D0A09097D20656C7365207B0D0A090D0A090909617065782E6A517565727928222E612D4952522D7461626C6520746822292E656163682866756E6374696F6E2870';
wwv_flow_api.g_varchar2_table(7) := '496E646578297B0D0A0D0A09090909617065782E6A51756572792874686973292E63737328227A2D696E646578222C2070496E64657820293B0D0A0909097D293B0D0A09097D0D0A090D0A09092F2F20636F6E74726F6C20627265616B202F2061706578';
wwv_flow_api.g_varchar2_table(8) := '20352E300D0A090969662028206C4973417065785F345F32203D3D2027302720262620617065782E6A517565727928222E612D4952522D7461626C652074682E612D4952522D6865616465722D2D67726F757022292E6C656E677468203E20302029207B';
wwv_flow_api.g_varchar2_table(9) := '0D0A09090D0A090909617065782E6A517565727928222E612D4952522D7461626C652074682E612D4952522D6865616465722D2D67726F757022292E666972737428292E636C6F736573742822747222292E6E6578742822747222292E6368696C647265';
wwv_flow_api.g_varchar2_table(10) := '6E282274682E612D4952522D68656164657222292E656163682866756E6374696F6E2870496E646578297B0D0A0909090D0A09090909766172206C4964203D20617065782E6A51756572792874686973292E617474722822696422293B0D0A0909090976';
wwv_flow_api.g_varchar2_table(11) := '6172206C44617461436F6C756D6E203D20617065782E6A51756572792874686973292E66696E6428222E612D4952522D6865616465724C696E6B22292E617474722822646174612D636F6C756D6E22293B0D0A0909090D0A09090909617065782E6A5175';
wwv_flow_api.g_varchar2_table(12) := '65727928222E612D4952522D7461626C652074682E612D4952522D6865616465722D2D67726F757022292E636C6F736573742822747222292E736C6963652831292E6E6578742822747222292E66696E64282274682E612D4952522D6865616465723A6E';
wwv_flow_api.g_varchar2_table(13) := '74682D6368696C642822202B202870496E6465782B3129202B222922292E61747472282263622D646174612D636F6C756D6E222C6C44617461436F6C756D6E293B0D0A0909097D293B0D0A09097D0D0A0D0A09092F2F2066697865642068656164657273';
wwv_flow_api.g_varchar2_table(14) := '202F206170657820352E300D0A090969662028206C4973417065785F345F32203D3D2027302720262620617065782E6A517565727928222E742D6668742D74626F647922292E6C656E677468203E20302029207B0D0A09090D0A090909617065782E6A51';
wwv_flow_api.g_varchar2_table(15) := '7565727928222E742D6668742D74626F64792074682E612D4952522D68656164657222292E65616368282066756E6374696F6E2870496E64657829207B0D0A0909090D0A09090909766172206C44617461436F6C756D6E203D20617065782E6A51756572';
wwv_flow_api.g_varchar2_table(16) := '792874686973292E66696E6428222E612D4952522D6865616465724C696E6B22292E617474722822646174612D636F6C756D6E22293B0D0A09090909617065782E6A51756572792874686973292E61747472282266682D646174612D636F6C756D6E222C';
wwv_flow_api.g_varchar2_table(17) := '6C44617461436F6C756D6E293B0D0A0909097D293B0D0A09097D0D0A09090D0A09092F2F207069766F7420726F7720636F6C756D6E73202F206170657820352E300D0A090969662028206C4973417065785F345F32203D3D202730272026262061706578';
wwv_flow_api.g_varchar2_table(18) := '2E6A517565727928222E612D4952522D7461626C652D2D7069766F7422292E6C656E677468203E20302029207B0D0A0D0A0909202020202F2F20776F726B7320696E206170657820352E302E340D0A090909766172206C526F77436F6C4E756D203D2061';
wwv_flow_api.g_varchar2_table(19) := '7065782E6A517565727928222E612D4952522D6865616465722D2D6E756C6C22292E617474722822636F6C7370616E22293B0D0A09090969662028216C526F77436F6C4E756D2920206C526F77436F6C4E756D203D20313B0D0A0909090D0A0909097661';
wwv_flow_api.g_varchar2_table(20) := '72206C4865616465724C696E65203D20617065782E6A517565727928222E612D4952522D7461626C652D2D7069766F743E74626F64793E74723E2A3A66697273742D6368696C642C2E612D4952522D7461626C652D2D7069766F743E74626F64793E7472';
wwv_flow_api.g_varchar2_table(21) := '3E2A3A66697273742D6368696C6422292E66696C74657228222E612D4952522D6865616465722D2D6E756C6C22292E6C656E6774683B0D0A0D0A090909617065782E6A517565727928222E612D4952522D7461626C652D2D7069766F74203E2074626F64';
wwv_flow_api.g_varchar2_table(22) := '79203E20747222292E6571286C4865616465724C696E65292E66696E642822746822292E736C69636528302C6C526F77436F6C4E756D292E65616368282066756E6374696F6E2870496E64657829207B0D0A0D0A09090909766172206C4964203D206170';
wwv_flow_api.g_varchar2_table(23) := '65782E6A51756572792874686973292E617474722822696422293B0D0A09090909766172206C44617461436F6C756D6E203D206C49642E73756273747228312C6C49642E696E6465784F6628225F22292D3120293B0D0A0D0A09090909617065782E6A51';
wwv_flow_api.g_varchar2_table(24) := '756572792874686973292E61747472282270722D646174612D636F6C756D6E222C6C44617461436F6C756D6E293B0D0A0909097D293B0D0A09097D0D0A097D293B0D0A090D0A09617065782E6A5175657279286C526567696F6E4964292E747269676765';
wwv_flow_api.g_varchar2_table(25) := '7228226170657861667465727265667265736822293B0D0A7D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 11861609775661512 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_file_name => 'irvh.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '0D0A5B5B4069663A2349535F415045585F345F32235D5D0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D204170657820342E3220';
wwv_flow_api.g_varchar2_table(2) := '3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A0D0A5B5B4069663A2349535F4E4F545F4C4F41444544235D5D0D0A0D0A2F2A203D3D3D';
wwv_flow_api.g_varchar2_table(3) := '3D3D3D3D3D204F6E636520466F7220416C6C20416374696F6E73203D3D3D3D3D3D3D3D202A2F0D0A0D0A09236170657869725F414354494F4E534D454E552C202E6468746D6C5375624D656E752C20236170657869725F636F6C756D6E73656172636820';
wwv_flow_api.g_varchar2_table(4) := '7B207A2D696E6465783A2033303030207D0D0A0D0A0D0A092F2A20666978206261636B67726F756E6420666F72206D756C74696C696E652068656164657273202A2F0D0A0D0A092E6170657869725F574F524B53484545545F44415441207468207B0D0A';
wwv_flow_api.g_varchar2_table(5) := '09096261636B67726F756E642D636F6C6F723A2023653765376537202120696D706F7274616E743B0D0A09096261636B67726F756E642D696D6167653A206E6F6E65202120696D706F7274616E743B0D0A097D0D0A0D0A0D0A092F2A206669782077726F';
wwv_flow_api.g_varchar2_table(6) := '6E672068656967687420696E2066697265666F78202A2F0D0A0D0A092E6170657869725F574F524B53484545545F44415441207472202F2A6469762C2074686561642C207461626C652A2F207B0D0A0D0A0909766572746963616C2D616C69676E3A2074';
wwv_flow_api.g_varchar2_table(7) := '6F703B0D0A097D0D0A0D0A0D0A092F2A206669782077726F6E672068656967687420696E206F706572610D0A09202020636F6E74656E742D626F782061732077656C6C2061732064656661756C747320617265206E6F7420776F726B696E672070726F70';
wwv_flow_api.g_varchar2_table(8) := '65726C7920696E206F706572612031322E31370D0A0D0A09202020626F726465722D626F7820686569676874203D20636F6E74656E74202B2070616464696E67202B20626F726465722D7769647468202A2F0D0A0D0A092E6170657869725F574F524B53';
wwv_flow_api.g_varchar2_table(9) := '484545545F44415441207468207B200D0A0D0A0909626F782D73697A696E673A20626F726465722D626F783B200D0A09097765626B69742D626F782D73697A696E673A20626F726465722D626F783B200D0A09092D6D6F7A2D626F782D73697A696E673A';
wwv_flow_api.g_varchar2_table(10) := '20626F726465722D626F783B0D0A097D0D0A0D0A0D0A092F2A20697420697320776F726B61726F756E6420666F720D0A0920202068747470733A2F2F6275677A696C6C612E6D6F7A696C6C612E6F72672F73686F775F6275672E6367693F69643D333531';
wwv_flow_api.g_varchar2_table(11) := '36380D0A0920202068747470733A2F2F6275677A696C6C612E6D6F7A696C6C612E6F72672F73686F775F6275672E6367693F69643D363838353536202A2F0D0A0D0A097461626C652E6170657869725F574F524B53484545545F44415441207B0D0A0D0A';
wwv_flow_api.g_varchar2_table(12) := '0909626F726465722D636F6C6C617073653A207365706172617465202120696D706F7274616E74203B0D0A097D0D0A092E6170657869725F574F524B53484545545F444154412074682E63757272656E74207B20626F726465722D6C6566742D77696474';
wwv_flow_api.g_varchar2_table(13) := '683A20307078202120696D706F7274616E74207D0D0A0D0A0D0A0D0A095B5B4069663A2349535F4E4F545F4945235D5D0D0A20200D0A092F2A20666F72207A2D696E64657820746F20776F726B20696E2046462070726F70656C79206974206973206E65';
wwv_flow_api.g_varchar2_table(14) := '6365737361727920746F207365742072656C617469766520746F20616C6C20686561646572730D0A09202020686F7765766572206974206361757365732069653820746F2065617420626F7264657273202A2F0D0A0D0A092E6170657869725F574F524B';
wwv_flow_api.g_varchar2_table(15) := '53484545545F44415441207468207B20706F736974696F6E3A2072656C6174697665202120696D706F7274616E743B207D200D0A0D0A095B5B40656E642D69665D5D0D0A0D0A092E6170657869725F574F524B53484545545F44415441207464207B200D';
wwv_flow_api.g_varchar2_table(16) := '0A0D0A0909626F782D73697A696E673A20626F726465722D626F783B200D0A09097765626B69742D626F782D73697A696E673A20626F726465722D626F783B200D0A09092D6D6F7A2D626F782D73697A696E673A20626F726465722D626F783B0D0A097D';
wwv_flow_api.g_varchar2_table(17) := '0D0A092E6170657869725F574F524B53484545545F444154412074642E63757272656E74207B20626F726465722D6C6566742D77696474683A20307078202120696D706F7274616E74207D0D0A20200D0A202020202F2A20697420697320776F726B6172';
wwv_flow_api.g_varchar2_table(18) := '6F756E6420666F723A2054686520636C69636B61626C65206172656120666F7220746865206C61737420766572746963616C2068656164657220697320736F6D6574696D657320657874656E646564206F757473696465206F66204952207461626C652E';
wwv_flow_api.g_varchar2_table(19) := '202A2F0D0A20202020236170657869725F444154415F50414E454C207B0D0A09090D0A0909646973706C61793A20696E6C696E652D626C6F636B3B200D0A09096F766572666C6F773A2068696464656E3B0D0A097D0D0A5B5B40656E642D69665D5D0D0A';
wwv_flow_api.g_varchar2_table(20) := '0D0A2F2A203D3D3D3D3D3D3D3D3D204F6E636520466F72204561636820416374696F6E203D3D3D3D3D3D3D3D3D202A2F0D0A0D0A5B5B4069663A2349535F4C545F49455F3130235D5D0D0A0D0A092F2A205374796C657320666F722069653920616E6420';
wwv_flow_api.g_varchar2_table(21) := '6C6F776572200D0A092020207468697320697320776F726B61726F756E64206F662066757A7A79207465787420696E206965382C39202A2F0D0A20200D0A095B5B2354485F4449565F4C495354235D5D207B20666F6E742D7765696768743A206E6F726D';
wwv_flow_api.g_varchar2_table(22) := '616C202120696D706F7274616E743B207D0D0A0D0A5B5B40656E642D69665D5D0D0A20200D0A095B5B2354485F4C495354235D5D207B0D0A0D0A09096865696768743A205B5B40706C73716C3A23484549474854232B23424F524445525F484549474854';
wwv_flow_api.g_varchar2_table(23) := '5F53554D4D4D415259232B23424F54544F4D5F50414444494E47232B23544F505F50414444494E47235D5D70783B200D0A09096D696E2D77696474683A205B5B40706C73716C3A235749445448232B2352494748545F50414444494E47232B234C454654';
wwv_flow_api.g_varchar2_table(24) := '5F50414444494E47232B23424F524445525F57494454485F53554D4D4D415259235D5D7078202120696D706F7274616E743B0D0A0D0A090970616464696E672D626F74746F6D3A205B5B23424F54544F4D5F50414444494E47235D5D7078202120696D70';
wwv_flow_api.g_varchar2_table(25) := '6F7274616E743B0D0A090970616464696E672D72696768743A205B5B2352494748545F50414444494E47235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D746F703A205B5B23544F505F50414444494E47235D5D707820212069';
wwv_flow_api.g_varchar2_table(26) := '6D706F7274616E743B0D0A090970616464696E672D6C6566743A20307078202120696D706F7274616E743B0D0A0D0A0909706F736974696F6E3A2072656C6174697665202120696D706F7274616E743B0D0A097D0D0A20200D0A095B5B2354445F4C4953';
wwv_flow_api.g_varchar2_table(27) := '54235D5D207B0D0A090970616464696E672D6C6566743A205B5B234C4546545F50414444494E475F464F525F5441424C455F43454C4C235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D72696768743A205B5B2352494748545F';
wwv_flow_api.g_varchar2_table(28) := '50414444494E475F464F525F5441424C455F43454C4C235D5D7078202120696D706F7274616E743B0D0A097D0D0A0D0A095B5B2354485F4449565F4C495354235D5D207B0D0A0D0A09092F2A2D6D6F7A2D7472616E73666F726D3A20726F746174652839';
wwv_flow_api.g_varchar2_table(29) := '302E30646567293B2A2F20202F2A4646332E352B2A2F0D0A09092F2A2D6F2D7472616E73666F726D3A20726F746174652839302E30646567293B2A2F20202F2A4F706572612031302E352A2F0D0A09092F2A2D7765626B69742D7472616E73666F726D3A';
wwv_flow_api.g_varchar2_table(30) := '20726F746174652839302E30646567293B2A2F20202F2A536166332E312B2C204368726F6D652A2F0D0A09092F2A66696C7465723A70726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E4261736963496D61676528726F';
wwv_flow_api.g_varchar2_table(31) := '746174696F6E3D31293B2A2F20202F2A4945362C4945372A2F0D0A09092F2A2D6D732D66696C7465723A70726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E4261736963496D61676528726F746174696F6E3D31293B2A';
wwv_flow_api.g_varchar2_table(32) := '2F202F2A4945382A2F0D0A09092F2A6C6566743A2D31363070783B2A2F0D0A0D0A09092D6D6F7A2D7472616E73666F726D3A20726F74617465283237302E30646567293B20202F2A4646332E352B2A2F0D0A09092D6F2D7472616E73666F726D3A20726F';
wwv_flow_api.g_varchar2_table(33) := '74617465283237302E30646567293B20202F2A4F706572612031302E352A2F0D0A09092D7765626B69742D7472616E73666F726D3A20726F74617465283237302E30646567293B20202F2A536166332E312B2C204368726F6D652A2F0D0A090966696C74';
wwv_flow_api.g_varchar2_table(34) := '65723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E4261736963496D61676528726F746174696F6E3D33293B20202F2A4945362C4945372A2F0D0A09092D6D732D66696C7465723A2070726F6769643A445849';
wwv_flow_api.g_varchar2_table(35) := '6D6167655472616E73666F726D2E4D6963726F736F66742E4261736963496D61676528726F746174696F6E3D33293B202F2A4945382A2F0D0A09097472616E73666F726D3A20726F7461746528323730646567293B0D0A0D0A0909626F782D73697A696E';
wwv_flow_api.g_varchar2_table(36) := '673A636F6E74656E742D626F783B0D0A0920200D0A09092F2A2073657474696E672077696474682F68656967687420746F206E6F6E657175616C2076616C7565732073686966747320746865207465787420736F20746869732069732074686520776F72';
wwv_flow_api.g_varchar2_table(37) := '6B61726F756E64202A2F0D0A09096865696768743A205B5B40706C73716C3A23484549474854232B23424F54544F4D5F50414444494E47232B23544F505F50414444494E47232D234C4546545F50414444494E47235D5D70783B0D0A090977696474683A';
wwv_flow_api.g_varchar2_table(38) := '205B5B23484549474854235D5D70783B200D0A0D0A0909706F736974696F6E3A206162736F6C757465202120696D706F7274616E743B0D0A0909646973706C61793A207461626C652D63656C6C3B200D0A0920200D0A0909766572746963616C2D616C69';
wwv_flow_api.g_varchar2_table(39) := '676E3A20746F703B0D0A0D0A0909746F703A20303B0D0A0920200D0A09095B5B4069663A2349535F484F52495A4F4E54414C5F504F534954494F4E5F4C454654235D5D6C6566743A20303B5B5B40656E642D69665D5D0D0A09095B5B4069663A2349535F';
wwv_flow_api.g_varchar2_table(40) := '484F52495A4F4E54414C5F504F534954494F4E5F43454E544552235D5D6C6566743A205B5B40706C73716C3A746F5F63686172287472756E6328235749445448232F322D234C494E455F484549474854232A234C494E4553232F322C32292C27666D3939';
wwv_flow_api.g_varchar2_table(41) := '393930443030272C274E4C535F4E554D455249435F43484152414354455253203D2027272E2C272727295D5D70783B5B5B40656E642D69665D5D0D0A09095B5B4069663A2349535F484F52495A4F4E54414C5F504F534954494F4E5F5249474854235D5D';
wwv_flow_api.g_varchar2_table(42) := '6C6566743A205B5B40706C73716C3A235749445448232D234C494E455F484549474854232A234C494E4553235D5D70783B5B5B40656E642D69665D5D0D0A0920200D0A09095B5B4069663A2349535F564552544943414C5F504F534954494F4E5F544F50';
wwv_flow_api.g_varchar2_table(43) := '235D5D746578742D616C69676E3A207269676874202120696D706F7274616E743B5B5B40656E642D69665D5D0D0A09095B5B4069663A2349535F564552544943414C5F504F534954494F4E5F4D4944444C45235D5D746578742D616C69676E3A2063656E';
wwv_flow_api.g_varchar2_table(44) := '746572202120696D706F7274616E743B5B5B40656E642D69665D5D0D0A09095B5B4069663A2349535F564552544943414C5F504F534954494F4E5F424F54544F4D235D5D746578742D616C69676E3A206C656674202120696D706F7274616E743B5B5B40';
wwv_flow_api.g_varchar2_table(45) := '656E642D69665D5D0D0A0D0A090970616464696E672D72696768743A205B5B23544F505F50414444494E47235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D746F703A205B5B234C4546545F50414444494E47235D5D70782021';
wwv_flow_api.g_varchar2_table(46) := '20696D706F7274616E743B0D0A090970616464696E672D6C6566743A205B5B23424F54544F4D5F50414444494E47235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D626F74746F6D3A20307078202120696D706F7274616E743B';
wwv_flow_api.g_varchar2_table(47) := '0D0A0D0A09095B5B4069663A2349535F4C494E455F4845494748545F4E4F545F4E554C4C235D5D0D0A0D0A09096C696E652D6865696768743A205B5B234C494E455F484549474854235D5D7078202120696D706F7274616E743B0D0A0D0A09095B5B4065';
wwv_flow_api.g_varchar2_table(48) := '6E642D69665D5D0D0A097D0D0A0D0A5B5B40656E642D69665D5D0D0A0D0A0D0A0D0A0D0A0D0A0D0A5B5B4069663A2349535F4E4F545F415045585F345F32235D5D0D0A0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(49) := '3D3D3D3D3D3D3D3D3D3D202A2F0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D204170657820352E30203D3D3D3D3D3D3D3D3D3D3D3D3D3D202A2F0D0A2F2A203D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D';
wwv_flow_api.g_varchar2_table(50) := '3D3D202A2F0D0A0D0A5B5B4069663A2349535F4E4F545F4C4F41444544235D5D0D0A0D0A092E612D4952522D6865616465724C696E6B3A666F637573207B0D0A0D0A0909626F782D736861646F773A206E6F6E65202120696D706F7274616E743B0D0A09';
wwv_flow_api.g_varchar2_table(51) := '7D0D0A0D0A092E612D4952522D636F6C5365617263682C202E612D4D656E752C202E612D4952522D736F7274576964676574207B207A2D696E6465783A2033303030207D0D0A0D0A0D0A092E612D4952522D7461626C65207468207B0D0A09096261636B';
wwv_flow_api.g_varchar2_table(52) := '67726F756E642D636F6C6F723A2023653765376537202120696D706F7274616E743B0D0A09096261636B67726F756E642D696D6167653A206E6F6E65202120696D706F7274616E743B0D0A097D0D0A0D0A092E612D4952522D7461626C65207472207B0D';
wwv_flow_api.g_varchar2_table(53) := '0A0D0A0909766572746963616C2D616C69676E3A20746F703B0D0A097D0D0A0D0A092E612D4952522D7461626C65207468207B200D0A0D0A0909626F782D73697A696E673A626F726465722D626F783B200D0A09097765626B69742D626F782D73697A69';
wwv_flow_api.g_varchar2_table(54) := '6E673A626F726465722D626F783B200D0A09092D6D6F7A2D626F782D73697A696E673A626F726465722D626F783B0D0A097D0D0A0D0A097461626C652E612D4952522D7461626C65207B0D0A0D0A0909626F726465722D636F6C6C617073653A20736570';
wwv_flow_api.g_varchar2_table(55) := '6172617465202120696D706F7274616E74203B0D0A097D0D0A092E612D4952522D7461626C652074682E63757272656E74207B20626F726465722D6C6566742D77696474683A20307078202120696D706F7274616E74207D0D0A0D0A0D0A0D0A095B5B40';
wwv_flow_api.g_varchar2_table(56) := '69663A2349535F4E4F545F4945235D5D0D0A0D0A092E612D4952522D7461626C65207468207B20706F736974696F6E3A2072656C6174697665202120696D706F7274616E743B207D200D0A0D0A095B5B40656E642D69665D5D0D0A0D0A092E612D495252';
wwv_flow_api.g_varchar2_table(57) := '2D7461626C65207464207B200D0A0D0A0909626F782D73697A696E673A20626F726465722D626F783B200D0A09097765626B69742D626F782D73697A696E673A20626F726465722D626F783B200D0A09092D6D6F7A2D626F782D73697A696E673A20626F';
wwv_flow_api.g_varchar2_table(58) := '726465722D626F783B0D0A097D0D0A092E612D4952522D7461626C652074642E63757272656E74207B20626F726465722D6C6566742D77696474683A20307078202120696D706F7274616E74207D0D0A0D0A092E742D6668742D74626F6479202E612D49';
wwv_flow_api.g_varchar2_table(59) := '52522D686561646572207B0D0A090D0A0909626F726465722D626F74746F6D2D77696474683A20307078202120696D706F7274616E743B0D0A097D0D0A090D0A092E742D6668742D74626F6479207B0D0A090D0A09096D617267696E2D746F703A202D31';
wwv_flow_api.g_varchar2_table(60) := '7078202120696D706F7274616E743B0D0A097D0D0A090D0A092E612D4952522D7461626C65436F6E7461696E6572207B0D0A09090D0A092020646973706C61793A20696E6C696E652D626C6F636B3B0D0A0920206F766572666C6F773A2068696464656E';
wwv_flow_api.g_varchar2_table(61) := '3B0D0A097D0D0A5B5B40656E642D69665D5D0D0A0D0A0D0A095B5B2354485F4C495354235D5D2C5B5B23434F4E54524F4C425245414B5F54485F4C495354235D5D2C5B5B235049564F545F524F575F54485F4C495354235D5D207B0D0A0D0A0909686569';
wwv_flow_api.g_varchar2_table(62) := '6768743A205B5B40706C73716C3A23484549474854232B23424F524445525F4845494748545F53554D4D4D415259232B23424F54544F4D5F50414444494E47232B23544F505F50414444494E47235D5D70783B200D0A09096D696E2D77696474683A205B';
wwv_flow_api.g_varchar2_table(63) := '5B40706C73716C3A235749445448232B2352494748545F50414444494E47232B234C4546545F50414444494E47232B23424F524445525F57494454485F53554D4D4D415259235D5D7078202120696D706F7274616E743B0D0A0D0A090970616464696E67';
wwv_flow_api.g_varchar2_table(64) := '2D626F74746F6D3A205B5B23424F54544F4D5F50414444494E47235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D72696768743A205B5B2352494748545F50414444494E47235D5D7078202120696D706F7274616E743B0D0A09';
wwv_flow_api.g_varchar2_table(65) := '0970616464696E672D746F703A205B5B23544F505F50414444494E47235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D6C6566743A20307078202120696D706F7274616E743B0D0A0D0A0909706F736974696F6E3A2072656C61';
wwv_flow_api.g_varchar2_table(66) := '74697665202120696D706F7274616E743B0D0A097D0D0A090D0A095B5B2354445F4C495354235D5D207B0D0A090970616464696E672D6C6566743A205B5B234C4546545F50414444494E475F464F525F5441424C455F43454C4C235D5D7078202120696D';
wwv_flow_api.g_varchar2_table(67) := '706F7274616E743B0D0A090970616464696E672D72696768743A205B5B2352494748545F50414444494E475F464F525F5441424C455F43454C4C235D5D7078202120696D706F7274616E743B0D0A097D0D0A0D0A095B5B2354485F415F4C495354235D5D';
wwv_flow_api.g_varchar2_table(68) := '2C5B5B23434F4E54524F4C425245414B5F54485F5350414E5F4C495354235D5D2C5B5B235049564F545F524F575F54485F415F4C495354235D5D207B0D0A0D0A09092D6D6F7A2D7472616E73666F726D3A20726F74617465283237302E30646567293B20';
wwv_flow_api.g_varchar2_table(69) := '0D0A09092D6F2D7472616E73666F726D3A20726F74617465283237302E30646567293B200D0A09092D7765626B69742D7472616E73666F726D3A20726F74617465283237302E30646567293B200D0A090966696C7465723A2070726F6769643A4458496D';
wwv_flow_api.g_varchar2_table(70) := '6167655472616E73666F726D2E4D6963726F736F66742E4261736963496D61676528726F746174696F6E3D33293B20200D0A09092D6D732D66696C7465723A2070726F6769643A4458496D6167655472616E73666F726D2E4D6963726F736F66742E4261';
wwv_flow_api.g_varchar2_table(71) := '736963496D61676528726F746174696F6E3D33293B200D0A09097472616E73666F726D3A20726F7461746528323730646567293B0D0A0D0A0909626F782D73697A696E673A20626F726465722D626F783B0D0A09090D0A09096865696768743A205B5B40';
wwv_flow_api.g_varchar2_table(72) := '706C73716C3A23484549474854232B23424F54544F4D5F50414444494E47232B23544F505F50414444494E47235D5D70783B0D0A090977696474683A205B5B40706C73716C3A23484549474854232B23424F54544F4D5F50414444494E47232B23544F50';
wwv_flow_api.g_varchar2_table(73) := '5F50414444494E47235D5D70783B200D0A0D0A0909706F736974696F6E3A206162736F6C757465202120696D706F7274616E743B0D0A0909646973706C61793A207461626C652D63656C6C3B0D0A0920200D0A0909766572746963616C2D616C69676E3A';
wwv_flow_api.g_varchar2_table(74) := '20746F703B0D0A0D0A0909746F703A20303B0D0A09090D0A09095B5B4069663A2349535F484F52495A4F4E54414C5F504F534954494F4E5F4C454654235D5D6C6566743A20303B5B5B40656E642D69665D5D0D0A09095B5B4069663A2349535F484F5249';
wwv_flow_api.g_varchar2_table(75) := '5A4F4E54414C5F504F534954494F4E5F43454E544552235D5D6C6566743A205B5B40706C73716C3A746F5F63686172287472756E6328235749445448232F322D234C494E455F484549474854232A234C494E4553232F322C32292C27666D393939393044';
wwv_flow_api.g_varchar2_table(76) := '3030272C274E4C535F4E554D455249435F43484152414354455253203D2027272E2C272727295D5D70783B5B5B40656E642D69665D5D0D0A09095B5B4069663A2349535F484F52495A4F4E54414C5F504F534954494F4E5F5249474854235D5D6C656674';
wwv_flow_api.g_varchar2_table(77) := '3A205B5B40706C73716C3A235749445448232D234C494E455F484549474854232A234C494E4553235D5D70783B5B5B40656E642D69665D5D0D0A09090D0A09095B5B4069663A2349535F564552544943414C5F504F534954494F4E5F544F50235D5D7465';
wwv_flow_api.g_varchar2_table(78) := '78742D616C69676E3A207269676874202120696D706F7274616E743B5B5B40656E642D69665D5D0D0A09095B5B4069663A2349535F564552544943414C5F504F534954494F4E5F4D4944444C45235D5D746578742D616C69676E3A2063656E7465722021';
wwv_flow_api.g_varchar2_table(79) := '20696D706F7274616E743B5B5B40656E642D69665D5D0D0A09095B5B4069663A2349535F564552544943414C5F504F534954494F4E5F424F54544F4D235D5D746578742D616C69676E3A206C656674202120696D706F7274616E743B5B5B40656E642D69';
wwv_flow_api.g_varchar2_table(80) := '665D5D0D0A0D0A090970616464696E672D72696768743A205B5B23544F505F50414444494E47235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D746F703A205B5B234C4546545F50414444494E47235D5D7078202120696D706F';
wwv_flow_api.g_varchar2_table(81) := '7274616E743B0D0A090970616464696E672D6C6566743A205B5B23424F54544F4D5F50414444494E47235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D626F74746F6D3A20307078202120696D706F7274616E743B0D0A0D0A09';
wwv_flow_api.g_varchar2_table(82) := '095B5B4069663A2349535F4C494E455F4845494748545F4E4F545F4E554C4C235D5D0D0A0D0A09096C696E652D6865696768743A205B5B234C494E455F484549474854235D5D7078202120696D706F7274616E743B0D0A0D0A09095B5B40656E642D6966';
wwv_flow_api.g_varchar2_table(83) := '5D5D0D0A09090D0A09095B5B4069663A2349535F4C545F49455F3130235D5D20666F6E742D7765696768743A206E6F726D616C202120696D706F7274616E743B205B5B40656E642D69665D5D0D0A097D0D0A200D0A095B5B2346495845445F54485F4C49';
wwv_flow_api.g_varchar2_table(84) := '5354235D5D207B0D0A09090D0A09096D696E2D77696474683A205B5B40706C73716C3A235749445448232B2352494748545F50414444494E47232B234C4546545F50414444494E47232B23424F524445525F57494454485F53554D4D4D415259235D5D70';
wwv_flow_api.g_varchar2_table(85) := '78202120696D706F7274616E743B0D0A09090D0A090970616464696E672D72696768743A205B5B2352494748545F50414444494E47235D5D7078202120696D706F7274616E743B0D0A090970616464696E672D6C6566743A20307078202120696D706F72';
wwv_flow_api.g_varchar2_table(86) := '74616E743B0D0A097D0D0A090D0A095B5B2346495845445F54485F415F4C495354235D5D207B0D0A0D0A090977696474683A205B5B40706C73716C3A235749445448232B234C4546545F50414444494E47235D5D7078202120696D706F7274616E743B0D';
wwv_flow_api.g_varchar2_table(87) := '0A0D0A090970616464696E672D6C6566743A205B5B234C4546545F50414444494E47235D5D7078202120696D706F7274616E743B0D0A09096F766572666C6F773A2068696464656E3B0D0A097D0D0A5B5B40656E642D69665D5D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 11862403841839605 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 18455816126983361 + wwv_flow_api.g_id_offset
 ,p_file_name => 'irvh_dynamic.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
