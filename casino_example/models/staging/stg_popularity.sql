with popularity as (
    select
        cg.game_id,
        cb.created_date as date,
        cb.bet_id,
        cb.user_id,
        cb.bet_amount,
        cb.win_amount,
        cb.ggr,
        cb.fsb
    from
        {{ ref('stg_trd_casino_bets') }} as cb
    left join
        {{ ref('stg_trd_casino_games') }} as cg
        on cb.game_id = cg.game_id
)

select
    game_id,
    date,
    count(distinct bet_id) as bets,
    count(case when ggr > 0 then bet_id end) / nullif(count(distinct user_id), 0) as bets_per_user,
    count(case when fsb = 1 then bet_id end) as free_spins
from
    popularity
group by
    game_id,
    date
