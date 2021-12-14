ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
    if Config.createOffDutyOnStartUp then 
        for job, data in pairs(Config.Jobs) do
            MySQL.Async.execute("INSERT INTO jobs(name, label) VALUES (@name, @label) on duplicate key update label = values(`label`) ",
                {
                    ["@name"] = Config.OffDutyPrefix .. job,
                    ["@label"] = Config.OffDutyName
                }
            )
            MySQL.Async.execute("insert into job_grades (id,job_name, grade, name, label, salary, skin_male, skin_female) select (-1*id),@jobname, grade, name, label, @salery,'{}','{}' from job_grades where job_name = @jobname_induty on duplicate key update job_name = values(`job_name`),grade = values(`grade`),name = values(`name`),label = values(`label`),salary = values(`salary`)",
                {
                    ["@jobname"] = Config.OffDutyPrefix .. job,
                    ["@salery"] = Config.OffDutySalery,
                    ["@jobname_induty"] = job
                }
            )

            Citizen.Wait(Config.CreateWaittime)
        end
    end 
end)

RegisterServerEvent("DaDuty:go-onoff")
AddEventHandler('DaDuty:go-onoff', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    assert(xPlayer ~= nil, "xPlayer could not be found")

    local currentjob = xPlayer.job.name
    local grade = xPlayer.job.grade

    local destinationjob = ""

    local isOffDuty = IsOffDuty(currentjob, Config.OffDutyPrefix)



    local ReturnText  = ""

    if isOffDuty then
        destinationjob = getInDutyName(currentjob, Config.OffDutyPrefix)
        ReturnText = Translations[Config.Locale].got_in_duty
    else
        destinationjob = getOffDutyName(currentjob, Config.OffDutyPrefix)
        ReturnText = Translations[Config.Locale].got_off_duty
    end

    xPlayer.setJob(destinationjob, grade)



    TriggerClientEvent("DaDuty:notification", _source, ReturnText)
end)


function IsOffDuty(Jobname, Prefix)
    return string.sub(Jobname,1,string.len(Prefix))==Prefix
 end

function getOffDutyName(Jobname, Prefix)
    return Prefix .. Jobname
 end
function getInDutyName(Jobname, Prefix)
    return string.sub(Jobname,1 + string.len(Prefix) ,string.len(Jobname))
 end