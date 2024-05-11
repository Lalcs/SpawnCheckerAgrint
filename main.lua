-- 表示モード
-- 1:沸くまでの残りの時間表示
-- 2:沸く時間を表示
mode = 2;

-- 基準データ
SPAWN_TIME = {1323788460, 1323889260}

function OnInit()
  H.RegisterMenu("季節のアグリント", 1);
end

-- 執事のメニューが選択された場合
function OnMenu(id)
  -- 変数の局所化
  local now_time;

  -- メッセージのラベルの作成
  H.PlaySound(0, "r[1]rrrr[2]");

  -- 現在の時刻を取得
  now_time = os.time();

  -- 押されたボタンの判別
  if(id == 1) then
    agurinto(now_time);
  end
end

function agurinto(now)
  -- 変数の局所化
  local sec;
  local now_day;
  local spawn_day;
  local day_message
  local time_date;
  local season_name;

  -- 残り時間の取得
  get_time(now, SPAWN_TIME[1]);

  -- 季節を取得
  season_name = get_season_name(now);

  -- mode1
  if(mode == 1) then
    H.Say(1, Day .. "日 " .. Hour .. "時間 " .. Minute .. "分後");

  -- mode2
  elseif(mode == 2) then
    -- 出現時間表示
    sec = get_time_sec(Day, Hour, Minute);
    sec = sec + now;
    now_day = os.date("%d");
    spawn_day = os.date("%d", sec);
    spawn_month = os.date("%m", sec);
    day_message = spawn_day - now_day;
    time_date = os.date("%H時%M分", sec);

    if(day_message == 0) then
      day_message = "今日の";
    elseif(day_message == 1) then
      day_message = "明日の";
    elseif(day_message == 2) then
      day_message = "明後日の";
    else
      day_message = spawn_month .. "月" .. spawn_day .. "日 ";
    end

    H.Say(1, day_message .. time_date .. "ごろ");
  end
  H.Say(2, season_name .. "のアグリントが出現するにゃん。");
end

function get_time(now, bese_time)
  X = 223200 -  ((now - bese_time) % 223200);
  Day = math.floor(X / 86400);
  Hour = math.floor( (X - Day * 86400) / 3600 );
  Minute = math.floor( (X % 3600) / 60);
end

function get_game_time_m(now)
  local td;
  local gtm;

  td = now - SPAWN_TIME[1];
  gtm = math.floor(td / 223200);
  gtm = math.floor(gtm % 12);
  gtm = gtm + 1;

  return gtm;
end

function get_game_time_d(now)
  local td;
  local gtd;

  td = now - SPAWN_TIME[1];
  gtd = math.floor(td / 7200);
  gtd = math.floor(gtd % 31);
  gtd = gtd + 1;

  return gtd;
end

function get_season_name(now)
  local gtm;
  local season_name;

  gtm = get_game_time_m(now);
  gtm = gtm + 1;

  if(gtm == 13) then
    gtm = 1;
  end

  if(gtm == 3) or (gtm == 4) or (gtm == 5) then
    season_name = "春";
  elseif(gtm == 6) or (gtm == 7) or (gtm == 8)then
    season_name = "夏";
  elseif(gtm == 9) or (gtm == 10) or (gtm == 11) then
    season_name = "秋";
  elseif(gtm == 12) or (gtm == 1) or (gtm == 2) then
    season_name = "冬";
  end
  return season_name;
end

function get_time_sec(day, hour, min)
  local sec;

  sec = day * 86400;
  sec = sec + hour * 3600;
  sec = sec + min * 60;

  return sec;
end
