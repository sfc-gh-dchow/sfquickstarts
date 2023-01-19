create or replace procedure marketing.dev.day1_growth_pipeline_forecast_test_2023_01_18()
returns string
language python
runtime_version = '3.8'
packages = ('snowflake-snowpark-python', 'pandas', 'numpy', 'scikit-learn')
handler = 'main'
as
$$
## Data preparation
import pandas as pd
import numpy as np

## Snowflake connectors
import snowflake.snowpark.Session

## Preprocessing
from sklearn.preprocessing import LabelEncoder

## Models
from sklearn.ensemble import HistGradientBoostingClassifier
from sklearn.calibration import CalibratedClassifierCV

## Model helpers
from sklearn.model_selection import cross_val_score

def main(session):
    df = session.table('marketing.dev.qs_train').toPandas()
    df.columns = df.columns.str.lower()

    le = LabelEncoder()

    for feature in [
        "stage_name",
        "pipeline_source",
        "opp_type",
        "forecast_status_c",
        "owner_region",
        "account_industry",
    ]:
        df[feature + "_encoded"] = le.fit_transform(df[feature])

    print("Encoded Categorical Features:", "\n", df.info())

    feature_list = [feature + "_encoded" for feature in categorical_features] + [
        "quarters_remaining",
        "probability",
        "amount",
        "days_since_created_date",
        "days_since_sales_qualified_date",
        "is_sales_qualified",
        "days_since_technical_win_date",
        "have_technical_win",
        "deal_registration_populated",
        "next_steps_populated",
        "closing_this_quarter",
    ]

    ## train
    x_train = df[df["snapshot_quarter"] == "2023-Q1"][feature_list]
    y_train = df[df["snapshot_quarter"] == "2023-Q1"]["syn_target_won_0"] # 0 being this quarter

    ## validation
    x_test = df[df["snapshot_quarter"] == "2023-Q2"][feature_list]
    y_test = df[df["snapshot_quarter"] == "2023-Q2"]["syn_target_won_0"]

    ## this list should show which fields are categorical
    categorical_mask = [True] * len(categorical_features) + [False] * (
        len(x_train.columns) - len(categorical_features)
    )

    ## HGBC is generally a good choice for classification
    clf = HistGradientBoostingClassifier(
        categorical_features=categorical_mask, min_samples_leaf=5, random_state=42
    ).fit(x_train.values, y_train)
    scores = cross_val_score(clf, x_train.values, y_train, cv=5, scoring="roc_auc")
    print("Train:", np.mean(scores))
    scores = cross_val_score(clf, x_test.values, y_test, cv=5, scoring="roc_auc")
    print("Test:", np.mean(scores))


    ## train
    x_train = df[df["snapshot_quarter"] == "2023-Q1"][feature_list]
    y_train = df[df["snapshot_quarter"] == "2023-Q1"]["syn_target_won_1"] # 1 being next quarter

    ## validation
    x_test = df[df["snapshot_quarter"] == "2023-Q2"][feature_list]
    y_test = df[df["snapshot_quarter"] == "2023-Q2"]["syn_target_won_1"]

    ## this list should show which fields are categorical
    categorical_mask = [True] * len(categorical_features) + [False] * (
        len(x_train.columns) - len(categorical_features)
    )
    ## HGBC is generally a good choice for classification
    clf = HistGradientBoostingClassifier(
        categorical_features=categorical_mask, min_samples_leaf=5, random_state=42
    ).fit(x_train.values, y_train)
    scores = cross_val_score(clf, x_train.values, y_train, cv=5, scoring="roc_auc")
    print("Train:", np.mean(scores))
    scores = cross_val_score(clf, x_test.values, y_test, cv=5, scoring="roc_auc")
    print("Test:", np.mean(scores))

    ## calibrate scores to true prob
    clf_cal = CalibratedClassifierCV(base_estimator=clf).fit(x_train.values, y_train)

    pred = clf_cal.predict_proba(x_test.values)[:, 1]
    
    ## put results into a DataFrame to push to Snowflake
    frame = {
        "opp_id": df[df["snapshot_quarter"] == "2023-Q2"]["opp_id"],
        "field": "syn_target_won_1",
        "y_score": clf_cal.predict_proba(x_test.values)[:, 1],
    }
    model_results = pd.DataFrame(frame)
        
    print('Modeling Complete')
    
    # opp_model_detail.columns = list(map(lambda s: s.upper(), opp_model_detail.columns))

    model_results.columns = model_results.columns.str.upper()
    
    schema = StructType(
        [
         StructField("opp_id", StringType()), 
         StructField("field", StringType()),
         StructField("y_score", FloatType())
        ]
    )
    session.create_dataframe(model_results,schema).write.mode('overwrite').save_as_table('marketing.dev.dchow_pf_test')
    
    return 'success'
$$;


call marketing.dev.day1_growth_pipeline_forecast_test_2023_01_18();


select 
    *
    -- curr.opp_id
    -- , curr.acv
    -- , curr.key
    -- , curr.y_score as prod_y_score
    -- , sp.y_score as stored_proc_y_score
from marketing.dev.dchow_pf_test as sp
left join marketing.pipeline_analytics.opp_level_scores as curr
    on curr.opp_id = sp.opp_id
order by opp_id;