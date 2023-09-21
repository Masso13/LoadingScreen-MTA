loadstring(exports.dgs:dgsImportFunction())()

--[[ Configurações do Timer ]]--
local diviser = 100
local seconds = 5000
local images = 19
--[[ -=-=-=-=-=-=-=-=-=-=-=- ]]--

local is_visible = false
local is_first = false

local DownloadHUD = {}

function renderBackground() -- Renderiza o fundo com a animação
    DownloadHUD["FundoPreto"] = dgsCreateImage(0.0000, 0.0000, 1.0000, 1.0000, "frames/background.png", true)
    DownloadHUD["Fundo"] = dgsCreateImage(0.0000, 0.0000, 1.0000, 1.0000, "frames/fundo1.jpg", true, DownloadHUD.FundoPreto)

    local point = 1/diviser
    local delay = seconds/diviser

    local mode = 0
    local alpha = 1
    local sec = 0
    local npoint = -point
    local image_back = 1
    local image_next = 1
    DownloadHUD["timer"] = setTimer(
        function()
            if sec < seconds then
                alpha = alpha + npoint
                sec = sec + delay
            else
                sec = 0
                npoint = npoint * (-1)
                if alpha < 1 then
                    image_next = IfElse(image_next >= images, 1, image_next + 1)
                end
            end
            dgsSetAlpha(DownloadHUD.Fundo, alpha)
            if image_next ~= image_back then
                dgsImageSetImage(DownloadHUD.Fundo, "frames/fundo"..image_next..".jpg")
                image_back = image_next
            end
        end
    , delay, 0)
end


function renderProgressBar()
    DownloadHUD["ProgressBar"] = dgsCreateProgressBar(0.0265, 0.9206, 0.9522, 0.0417, true, DownloadHUD.Efeito, _, tocolor(189, 189, 189, 78), _, tocolor(254, 3, 3, 254))
    --[[dxDrawRectangle(screenW * 0.0265, screenH * 0.9206, screenW * 0.9522, screenH * 0.0417, tocolor(189, 189, 189, 78), false)
    dxDrawRectangle(screenW * 0.0265, screenH * 0.9206, screenW * 0.0735, screenH * 0.0417, tocolor(254, 3, 3, 254), false)
    dxDrawText("30%", screenW * 0.4140, screenH * 0.9206, screenW * 0.5971, screenH * 0.9622, tocolor(255, 255, 255, 255), 2.00, "default", "center", "center", false, false, false, false, false)]]
end

function DownloadDGS()
    renderBackground()
    DownloadHUD["Efeito"] = dgsCreateImage(0.0000, 0.0000, 1.0000, 1.0000, _, true, DownloadHUD.FundoPreto, tocolor(0, 0, 0, 0))
    renderProgressBar()
end

function switchDisplay()
    if DownloadHUD.Fundo then
        destroyElement(DownloadHUD.Fundo)
        destroyElement(DownloadHUD.FundoPreto)
        killTimer(DownloadHUD.timer)
        DownloadHUD = {}
        is_visible = false
        is_first = true
    else
        DownloadDGS()
        is_visible = true
    end
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
    function()
        if isTransferBoxActive() then
            switchDisplay()
        end
    end, false, "high"
)

addEventHandler("onClientTransferBoxProgressChange", root,
    function(totalLast, totalSize)
        if is_visible and not is_first then
            local percent = math.min((totalLast / totalSize) * 100, 100)
            dgsProgressBarSetProgress(DownloadHUD.ProgressBar, percent)
            if percent == 100 then
                switchDisplay()
            end
        end
    end, true, "high"
)