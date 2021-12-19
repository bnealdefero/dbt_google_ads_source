{{ config(enabled=var('api_source') == 'google_ads') }}

with base as (

    select * 
    from {{ ref('stg_google_ads__ad_group_stats_tmp') }}

),

fields as (

    select
        *
    from base
),

final as (
    
    select 
        _fivetran_synced,
        id,
        campaign_id,
        customer_id as account_id,
        date as date_day,
        lower(ad_network_type) as ad_network_type,
        clicks,
        cost_micros / 1000000.0 as spend,
        impressions
        {% for metric in var('google_ads__ad_group_stats_passthrough_metrics') %}
        , {{ metric }}
        {% endfor %}
    from fields

)

select * 
from final
