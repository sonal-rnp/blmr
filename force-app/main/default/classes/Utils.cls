/**
 * Created by sonal on 2021-07-07.
 */

public with sharing class Utils {

    public static Boolean isChanged(SObject aObj, Schema.SObjectField aField) {
        return Trigger.isInsert ||
                aObj.get(String.valueOf(aField)) != Trigger.oldMap.get(aObj.Id).get(String.valueOf(aField));
    }
}