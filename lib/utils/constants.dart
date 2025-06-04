// final String baseUrl = "http://localhost:8000/";
final String baseUrl = "https://7hmgmjzr-3000.inc1.devtunnels.ms";



/// ** AUTH URLs  ***

final String loginUrl = "/worker/login";



/// ** CLEANER URLs ***

String getCleanerPlantsInfoUrl(int inspectorId) => "/api/plant/cleaner/$inspectorId";







/// ** INSPECTOR URLs ***

String getInspectorPlantsUrl(int inspectorId) => "/api/plant/inspector/$inspectorId";


String getAllPlant(int inspectorId) => "/schedules/inspector-schedules/inspector/$inspectorId/weekly";


String getTodaySchedule(int inspectorId) => "/schedules/inspector-schedules/today/$inspectorId";



String submitInspectionReport = "/api/report/cleaner-reports";







