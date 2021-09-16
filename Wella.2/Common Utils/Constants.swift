//
//  Constants.swift
//  Wella.2

//  Created by Acxiom Consulting on 17/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.

import UIKit
public class Constants {
    public static let BASE_URL = "http://104.211.186.102:1443/api/"
    //   uat
   // public static let BASE_URL="http://163.47.143.188:4808/api/"
    //live
  //    public static let BASE_URL = "http://wellanavision.com:4803/api/"
    public static let URL_GET_list = "GetBrandGroupDashBoard?USERID=" + UserDefaults.standard.string(forKey: "userid")!
    public static let URL_PIChart="GetChannelGroupDashboard?USERID=" + UserDefaults.standard.string(forKey: "userid")!
    public static let URL_GET_PROFILE="UserProfile?TRAINERCODE=" + UserDefaults.standard.string(forKey: "userid")!
    public static let URL_GET_Branchspinner = "GetFilterDetails?&SEARCHTYPE=1&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    public static let URL_GetDtrlist = "GetTrainingReport?&TRAINIR=" + UserDefaults.standard.string(forKey: "userid")! + "&FROMDATE="
    public static let URL_GetMyStylist = "GetStylistReport?&usercode=" + UserDefaults.standard.string(forKey: "userid")! + "&fromdate=" 
    public static let URL_getMyInSalon1 = "GetFilterDetails?SEARCHTYPE=7&SEARCHBY1="
    public static let URL_getMyInSalon2 = "&SEARCHBY2=%22%22"
    public static let URL_getTrainingdata = "GetFilterDetails?&SEARCHTYPE=6&SEARCHBY1=%2522%2522&SEARCHBY2=%2522%2522"
    public static let URL_Postinsalon = "PostTrainingInsalon?UserCode=" + UserDefaults.standard.string(forKey: "userid")! + "&DataAreaId=7200"
    public static let URL_postworkshop = "PostTrainingWorkShop?UserCode=" + UserDefaults.standard.string(forKey: "userid")! + "&DataAreaId=7200"
    public static let URL_AddstylistCategory =  "GetFilterDetails?&SEARCHTYPE=3&SEARCHBY1=%2522%2522&SEARCHBY2=%2522%2522"
    public static let URL_Addstylistlevel = "GetFilterDetails?&SEARCHTYPE=4&SEARCHBY1=%2522%2522&SEARCHBY2=%2522%2522"
    public static let URL_GETStylistdetail = "GetStylistDetails?&CONTACT="
    public static let URl_salontracking = "GetSalonTracking?PSRCODE=" + UserDefaults.standard.string(forKey: "psrcode")!+"&CUSTOMERCODE="+UserDefaults.standard.string(forKey: "customercode")!
    public static let URL_AddStylistdetail = "PostStylistMaster_V1"
    public static let URL_dashboardfirstlevel = "GetFilterDetails?&SEARCHTYPE=8&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    public static let URL_dashboardSecondlevel = "GetFilterDetails?&SEARCHTYPE=9&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_PostSynclog = "SyncLogTable"
    
    public static let URL_POSTSENDOTP = "POSTSendOTP"
    
    public static let URL_dashboardDsu = "GetFilterDetails?&SEARCHTYPE=8&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_PieChart = "GetFilterDetails?&SEARCHTYPE=15&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_trainingLineChart = "GetFilterDetails?&SEARCHTYPE=16&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_StylistLineChart = "GetFilterDetails?&SEARCHTYPE=17&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URl_salontracking_new = "GetSalonTracking?PSRCODE=" + UserDefaults.standard.string(forKey: "userid")!+"&CUSTOMERCODE="
    
    public static let URL_SalonDetails = "GetFilterDetails?&SEARCHTYPE=13&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_CityMaster = "GetCityMaster"
    public static let URL_EditStylistDetailS = "POSTREQTOAPPROVETYPE2"
    public static let URL_POSTSendOTP = "POSTSendOTP"
    public static let URL_POSTVerifyOTP = "POSTVerifyOTP"
    
    public static let URL_POST_HOTDAY = "PostHotDay?UserCode=" + UserDefaults.standard.string(forKey: "userid")! + "&DataAreaId=7200"
    public static let URL_POST_ADD_LEAVE = "PostLeave?UserCode=" + UserDefaults.standard.string(forKey: "userid")! + "&DataAreaId=7200"
    
    public static let URL_POST_INTERNAL_TRAINING = "PostInternalTraining?UserCode=" + UserDefaults.standard.string(forKey: "userid")! + "&DataAreaId=7200"
    
    public static let URL_POST_OTHER_TRAINING = "PostOtherTraining?UserCode=" + UserDefaults.standard.string(forKey: "userid")! + "&DataAreaId=7200"
    
    public static let URL_GETSTYLISTDATA = "GetFilterDetails?SEARCHTYPE=12&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_POST_TRAINING_INSALON = "PostTrainingInSalon?UserCode=" + UserDefaults.standard.string(forKey: "userid")! + "&DataAreaId=7200"
    
    public static let URL_POST_TRAINING_WORKSHOP = "PostTrainingWorkshop?UserCode=" + UserDefaults.standard.string(forKey: "userid")! + "&DataAreaId=7200"
    
    public static let URL_Home_Prod = "GetFilterDetails?&SEARCHTYPE=19&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_Home_Prod_Unprod = "GetFilterDetails?&SEARCHTYPE=20&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_ColorLevel = "GetFilterDetails?&SEARCHTYPE=21&SEARCHBY1=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHBY2=%2522%2522"
    
    public static let URL_GET_PROFILE_NEW="UserProfileNew?TRAINERCODE=" + UserDefaults.standard.string(forKey: "userid")!
    
    public static let URL_GETTODAYTRAININGDATA = "GETTODAYTRAININGDATA?TRAINERCODE=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHTRAININGTYPE=2"
    
    public static let URL_GETTODAYWKSHPINSLNTRAININGDATA = "GETTODAYTRAININGDATA?TRAINERCODE=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHTRAININGTYPE=1"
      public static let URL_GETALLOWTRAININGTYPEMASTER = "GETALLOWTRAININGTYPEMASTER"
    
    public static let URL_GETTODAYMULTIWORKSHOP = "GETTODAYMULTIWORKSHOP?TRAINERCODE=" + UserDefaults.standard.string(forKey: "userid")! + "&SEARCHTRAININGTYPE=1"
    
    public static let URL_GetCalender = "GetCalender?TRAINERCODE=" + UserDefaults.standard.string(forKey: "userid")!
    
    public static let URL_GetCalenderPending = "GetCalenderPending?TRAINERCODE=" + UserDefaults.standard.string(forKey: "userid")!
    
    public static let URL_PostDeleteData = "DELETETODAYACTIVITYEDU"

    public static let URL_PostCalendar = "POSTREQTOAPPROVE"
    
}

