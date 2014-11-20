-- $Id: localization.kr.lua 145 2011-09-10 03:36:12Z arithmandar $
-- [[
-- Language: Korean
-- Translated by: gygabyte, talkswind
-- Last Updated: $Date: 2011-09-10 11:36:12 +0800 (Sat, 10 Sep 2011) $
-- ]]
--------------------------
-- Translatable strings --
--------------------------
if (GetLocale() == "koKR") then
FQ_Formats = {
	"퀘스트이름",
	"[퀘스트레벨] 퀘스트이름",
	"[퀘스트레벨+] 퀘스트이름",
	"[퀘스트레벨+] 퀘스트이름 (꼬리표)",
};
--
EPA_TestPatterns = {
	"^(.+): %s*[-%d]+%s*/%s*[-%d]+%s*$",
	"^퀘스트를 완료했습니다: .+$",			-- ERR_QUEST_COMPLETE_S
	"^(.+)\(완료)$",				-- ERR_QUEST_OBJECTIVE_COMPLETE_S
--	"^퀘스트를 수락했습니다: .+$",			-- ERR_QUEST_ACCEPTED_S
	"^경험치를 획득했습니다: .+ XP$",			-- ERR_QUEST_REWARD_EXP_I
	"(.+)|1을;를; 발견했습니다",			-- ERR_ZONE_EXPLORED
};
	-- Below messages are used in EPA_TestPatterns
	-- ERR_QUEST_COMPLETE_S 		= "퀘스트를 완료했습니다: %s";
	-- ERR_QUEST_OBJECTIVE_COMPLETE_S 	= "%s (완료)"; -- %s is the objective text
	-- ERR_QUEST_ACCEPTED_S 		= "퀘스트를 수락했습니다: %s"; -- %s is the quest name
	-- ERR_QUEST_REWARD_EXP_I 		= "경험치를 획득했습니다: %d XP"; -- %d is amount of xp gain
	-- ERR_ZONE_EXPLORED 			= "%s|1을;를; 발견했습니다!";
--
	FQ_QUEST_TEXT = "(.*): %s*([-%d]+)%s*/%s*([-%d]+)%s*$";	-- ERR_QUEST_ADD_FOUND_SII = "%s: %d/%d", ERR_QUEST_ADD_ITEM_SII = "%s: %d/%d", ERR_QUEST_ADD_KILL_SII = "%s 처치: %d/%d"
--
	FQ_LOADED = "|cff00ffffFastQuest Classic"..FASTQUEST_CLASSIC_VERSION.."|1을 불러들였습니다. 보다 상세한 것은 /fq를 입력하세요. 옵션 창을 켜거나 끄려면 /fq options를 입력하세요.";
	FQ_INFO = "|cff00ffffFastQuest Classic: |r|cffffffff";
-- Strings in Option Frame
	FQ_OPT_OPTIONS_TITLE = "FastQuest Classic 옵션";
	FQ_OPT_FRM_NOTIFY_TITLE = "알림 옵션";
	FQ_OPT_AUTONOTIFY_TITLE = "자동 알림";
	FQ_OPT_AUTONOTIFY_TIP = "근처에 있는 사람, 파티원, 공격대원, 길드원에게 퀘스트와 관련된 정보를 자동으로 알립니다.";
	FQ_OPT_QUESTCOMPLETESOUND_TITLE = "퀘스트 완료 소리";
	FQ_OPT_QUESTCOMPLETESOUND_TIP = "퀘스트를 완료했을 경우에 알림 소리를 사용 혹은 미사용합니다.";
	FQ_OPT_NOTIFYCHANNEL_TITLE = "채널 알림";
	FQ_OPT_NOTIFYNEARBY_TITLE = "근처 알림";
	FQ_OPT_NOTIFYNEARBY_TIP = "퀘스트와 관련된 정보를 근처에 있는 사람에게 알립니다.";
	FQ_OPT_NOTIFYPARTY_TITLE = "파티 알림";
	FQ_OPT_NOTIFYPARTY_TIP = "퀘스트와 관련된 정보를 파티원에게 알립니다.";
	FQ_OPT_NOTIFYRAID_TITLE = "공격대 알림";
	FQ_OPT_NOTIFYRAID_TIP = "퀘스트와 관련된 정보를 공격대원에게 알립니다.";
	FQ_OPT_NOTIFYGUILD_TITLE = "길드 알림";
	FQ_OPT_NOTIFYGUILD_TIP = "퀘스트와 관련된 정보를 길드원에게 알립니다.";
	FQ_OPT_NOTIFYDETAIL_TITLE = "상세 알림";
	FQ_OPT_NOTIFYDETAIL_TIP = "퀘스트 진행사항을 상세하게 알립니다.";
	FQ_OPT_NOTIFYEXP_TITLE = "경험치 획득 알림";
	FQ_OPT_NOTIFYEXP_TIP = "완료한 퀘스트에서 얻은 경험치를 알립니다.";
	FQ_OPT_NOTIFYZONE_TITLE = "지역 발견 알림";
	FQ_OPT_NOTIFYZONE_TIP = "새로운 지역을 발견했을 때 알립니다.";
	FQ_OPT_NOTIFYLEVELUP_TITLE = "레벨업 알림";
	FQ_OPT_NOTIFYLEVELUP_TIP = "레벨업 정보를 알립니다.";
	FQ_OPT_FRM_QUESTFORMAT_TITLE = "퀘스트 표시 형식 설정";
	FQ_OPT_QUESTFORMAT_TITLE = "퀘스트 표시 형식 선택";
	FQ_OPT_QUESTFORMAT_TIP = "대화창에 표시할 퀘스트 표시 형식을 선택합니다.";
	FQ_OPT_QUESTLOGOPTIONS_TITLE = "퀘스트 로그 설정";
	FQ_OPT_COLOR_TITLE = "색상 켜기";
	FQ_OPT_COLOR_TIP = "퀘스트 추적창에 있는 퀘스트 제목을 퀘스트 난이도에 따른 서로 다른 색상으로 표시합니다.";
	FQ_OPT_MEMBERINFO_TITLE = "권장 파티원 수 표시";
	FQ_OPT_MEMBERINFO_TIP = "퀘스트 로그 창에 권장 파티원 수를 표시합니다.";
	FQ_OPT_MINIMAP_POSITION_TITLE = "미니맵 위치";
	FQ_OPT_SHOWTYPE_TITLE = "퀘스트 유형 표시";
	FQ_OPT_SHOWTYPE_TIP = "퀘스트 추적창에 퀘스트 유형을 표시합니다.";
	FQ_OPT_NODRAG_TITLE = "잡아 끌 수 없음";
	FQ_OPT_NODRAG_TIP = "퀘스트 추적창을 잡아 끌 수 없는 상태로 설정합니다.";
	FQ_OPT_LOCK_TITLE = "퀘스트 추적창 고정";
	FQ_OPT_LOCK_TIP = "퀘스트 추적창의 위치를 고정시킵니다.";
	FQ_OPT_AUTOADD_TITLE = "퀘스트 자동 추가/삭제";
	FQ_OPT_AUTOADD_TIP = "퀘스트 추적창에 퀘스트를 자동으로 추가 또는 삭제합니다.";
	FQ_OPT_AUTOCOMPLETE_TITLE = "자동 완료";
	FQ_OPT_AUTOCOMPLETE_TIP = "퀘스트를 자동으로 완료합니다.";
	FQ_OPT_FRM_MISC_TITLE = "기타 설정";
	FQ_OPT_SHOWMINIMAP_TITLE = "미니맵 아이콘 보이기";
	FQ_OPT_SHOWMINIMAP_TIP = "미니맵 아이콘 보이기 전환";
	FQ_OPT_SOUNDSELECTION = "알림 소리:";
	FQ_BTN_OK = "확인";
	FQ_BTN_ABOUT = "개요";
	FQ_BTN_PREVIEW = "미리보기";

	FQ_BUTTON_TOOLTIP = "퀘스트 목록을 열려면  왼쪽-클릭,\nFastQuest Classic 옵션은 가운데-클릭,\n이 버튼을 이동하려면 오른쪽-클릭과 잡아 끌기.";
	FQ_TITAN_BUTTON_TOOLTIP = "퀘스트 목록을 열려면 왼쪽-클릭, FastQuest Classic 옵션은 오른쪽-클릭.";

-- Information Message
	FQ_INFO_NOTIFYGUILD = "나의 퀘스트 진행사항을 길드원에게 알림: ";
	FQ_INFO_NOTIFYRAID = "나의 퀘스트 진행사항을 공격대원에게 알림: ";
	FQ_INFO_NOTIFYNEARBY = "나의 퀘스트 진행사항을 근처에 있는 사람에게 알림: ";
	FQ_INFO_NOTIFYPARTY = "나의 퀘스트 진행사항을 파티원에게 알림: ";
	FQ_INFO_AUTOADD = "퀘스트 추적창에/에서 변경된 퀘스트를 자동 추가와 혹은 삭제: ";
	FQ_INFO_AUTOCOMPLETE = "자동 퀘스트 완료: ";
	FQ_INFO_AUTONOTIFY = "나의 퀘스트 진행사항을 자동 알림: ";
	FQ_INFO_CLEAR = "퀘스트 추적창에 있는 모든 퀘스트가 삭제되었습니다.";
	FQ_INFO_COLOR = "서로 다른 색상으로 표시되기 위한 퀘스트 제목: ";
	FQ_INFO_DETAIL = "퀘스트 진행 세부사항 알림: ";
	FQ_INFO_DISPLAY_AS = "선택한 형식: ";
	FQ_INFO_FORMAT = "출력 형식간의 전환";
	FQ_INFO_LOCK = "이동 가능한 구성요소가 |cffff0000고정됨|r|cffffffff";
	FQ_INFO_QUESTCOMPLETESOUND = "퀘스트 완료 알림 소리:";
	FQ_INFO_MEMBERINFO = "퀘스트의 권장 파티원 수: ";
	FQ_INFO_NODRAG = "지금 잡아 끕니다.";
	FQ_INFO_NOTIFYDISCOVER = "당신이 발견한 새로운 지역 알림: ";
	FQ_INFO_NOTIFYEXP = "완료된 퀘스트에서 획득한 경험치 알림: ";
	FQ_INFO_NOTIFYLEVELUP = "레벨업 정보 알림: ";
	FQ_INFO_QUEST_TAG = "퀘스트 추적창에 퀘스트 태그(정예, PvP, 공격대 등등.) 표시: ";
	FQ_INFO_RESET = "퀘스트 추적창의 위치가 초기화 되었습니다.";
	FQ_INFO_SHOWMINIMAP = "미니맵에 아이콘 보이기";
	FQ_INFO_UNLOCK = "이동 가능한 구성요소가  |cff00ff00풀림|r|cffffffff";
	FQ_INFO_USAGE = "|cffffff00사용법: /fastquest [명령어] 혹은 /fq [명령어]|r|cffffffff";
--
	FQ_MUST_RELOAD = "당신은 변경된 사항을 적용할려면 UI를 재실행해야 합니다. /console reloadui 입력하세요";
--
	FQ_USAGE_NOTIFYGUILD = "길드원 자동 알림을 켜거나 끕니다.";
	FQ_USAGE_NOTIFYRAID = "공격대원 자동 알림을 켜거나 끕니다.";
	FQ_USAGE_NOTIFYNEARBY = "근처에 있는 사람 자동 알림을 켜거나 끕니다.";
	FQ_USAGE_NOTIFYPARTY = "파티원 자동 알림을 켜거나 끕니다.";
	FQ_USAGE_AUTOADD = "퀘스트 추적창에 변경한 퀘스트를 자동으로 추가하거나 하지 않습니다.";
	FQ_USAGE_AUTOCOMPLETE = "퀘스트 자동 완료를 켜거나 끕니다. (당신은 NPC로부터 퀘스트 완료를 볼 수 없을 겁니다.)";
	FQ_USAGE_AUTONOTIFY = "파티원 자동 알림을 켜거나 끕니다.";
	FQ_USAGE_CLEAR = "모든 퀘스트에서 퀘스트 추적창을 초기화합니다.";
	FQ_USAGE_COLOR = "퀘스트 추적창에 있는 퀘스트 제목을 색상화 하거나 하지 않습니다.";
	FQ_USAGE_DETAIL = "상세한 퀘스트 진행사항을 알리거나 알리지 않습니다.";
	FQ_USAGE_FORMAT = "퀘스트 출력 형식을 알립니다.";
	FQ_USAGE_LOCK = "퀘스트 추적창을 고정시키거나 고정시키지 않습니다.";
	FQ_USAGE_MEMBERINFO = "퀘스트의 권장 파티원 수를 표시하거나 표시하지 않습니다.";
	FQ_USAGE_NODRAG = "퀘스트 추적기 잡아 끌기 전환, 적용하려면 UI를 다시 불러들여야 합니다.";
	FQ_USAGE_NOTIFYDISCOVER = "새로운 지역을 발견했을 때의 자동 알림을 켜거나 끕니다.";
	FQ_USAGE_NOTIFYEXP = "퀘스트에서 획득한 경험치의 자동 알림을 켜거나 끕니다.";
	FQ_USAGE_NOTIFYLEVELUP = "레벨업 정보의 자동 알림을 켜거나 끕니다.";
	FQ_USAGE_RESET = "퀘스트 추적창의 위치를 초기화합니다.";
	FQ_USAGE_STATUS = "모든 FastQuest Classic 설정 상태를 표시합니다.";
	FQ_USAGE_OPTIONS = "설정 창을 열거나 닫습니다.";
	FQ_USAGE_TAG = "퀘스트 태그 표시를 켜거나 끕니다(정예, 공격대, 등등..) ";
--
	BINDING_HEADER_FASTQUEST_CLASSIC = "FastQuest Classic";
	BINDING_NAME_FASTQUEST_OPTIONS = "묻고 답하기 설정 전환";
	BINDING_NAME_FQ_TAG = "퀘스트 태그 전환";
	BINDING_NAME_FQ_FORMAT = "퀘스트 표시 형식";
	BINDING_NAME_FQ_AOUTNOTIFY = "자동 알림";
	BINDING_NAME_FQ_AOUTCOMPLETE = "퀘스트 자동 회부";
	BINDING_NAME_FQ_AOUTADD = "추적창에 퀘스트 자동 추가";
	BINDING_NAME_FQ_LOCK = "퀘스트 추적창 잠금/풀음";
--
	FQ_QUEST_PROGRESS = "퀘스트 진행사항: ";
	FQ_QUEST_ACCEPTED	= "퀘스트를 수락했습니다: ";
--
	FQ_QUEST_ISDONE = " 퀘스트를 완료했습니다!";
	FQ_QUEST_COMPLETED = " (퀘스트 완료)";
	FQ_DRAG_DISABLED = "FastQuest Classic: 잡아 끌기 기능이 비활성 상태입니다, 전환하려면 /fq nodrag를 사용하고, 변경된 것을 적용하기 위해 UI를 재시작해야만 합니다.";
--
	FQ_ENABLED = "|cff00ff00사용함|r|cffffffff";
	FQ_DISABLED = "|cffff0000사용하지 않음|r|cffffffff";
	FQ_LOCK = "|cffff0000고정됨|r|cffffffff";
	FQ_UNLOCK = "|cff00ff00풀림|r|cffffffff";
--
end