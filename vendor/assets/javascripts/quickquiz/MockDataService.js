var MockDataService = {
    getMockData:function () {
        return {
            "totalSize":10,
            "done":true,
            "records":[
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uIPIAY"
                    },
                    "Id":"a0xZ00000004uIPIAY",
                    "Question__c":"<script type=\"text/javascript\">\r\nfunction displayDate()\r\n{\r\ndocument.getElementByDiv(\"demo\").span=Date();\r\n}\r\n</script>\r\n\r\n<button type=\"button\" onclick=\"displayDate()\">Display Date</button>",
                    "Language__c":"JavaScript"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uIUIAY"
                    },
                    "Id":"a0xZ00000004uIUIAY",
                    "Question__c":"<script type=\"text/javascript\">\r\nvar i=0;\r\nfor (i=0;i<=5;i++)\r\n{\r\ndocument.output(\"The number is \" + i);\r\ndocument.output(\"<br />\");\r\n}\r\n</script>",
                    "Language__c":"JavaScript"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uIZIAY"
                    },
                    "Id":"a0xZ00000004uIZIAY",
                    "Question__c":"[ \"a\", \"c\" ]    == [ \"a\", \"c\", 7 ]     #=> true",
                    "Language__c":"Ruby"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uIeIAI"
                    },
                    "Id":"a0xZ00000004uIeIAI",
                    "Question__c":"[1, 2, 3, 4, 5].chomp(3)",
                    "Language__c":"Ruby"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uIjIAI"
                    },
                    "Id":"a0xZ00000004uIjIAI",
                    "Question__c":"[1, 2, 3, 4, 5].slice(3)",
                    "Language__c":"Ruby"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uIoIAI"
                    },
                    "Id":"a0xZ00000004uIoIAI",
                    "Question__c":"public static void main(String[] args) {\r\n \r\n     DateTime date = new DateTime();\r\n     String strDateFormat = \"HH:mm:ss a\";\r\n     SimpleDateFormat sdf = new SimpleDateFormat(strDateFormat);\r\n     \r\n     System.out.println(\"Time with AM/PM field : \" + sdf.format(date));\r\n \r\n}",
                    "Language__c":"Java"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uIpIAI"
                    },
                    "Id":"a0xZ00000004uIpIAI",
                    "Question__c":"<script type=\"text/javascript\">\r\nvar r=Math.random();\r\nif (r>1)\r\n{\r\ndocument.write(\"<a href='http://www.w3schools.com'>Learn Web Development!</a>\");\r\n}\r\nelse\r\n{\r\ndocument.write(\"<a href='http://www.refsnesdata.no'>Visit Refsnes Data!</a>\");\r\n}\r\n</script>",
                    "Language__c":"JavaScript"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uItIAI"
                    },
                    "Id":"a0xZ00000004uItIAI",
                    "Question__c":"public class ArrayCopy {\r\n  public static void main(String args[]) {\r\n    System.out.printf(\"Before (original)\\t%s%n\", Arrays.toString(args));\r\n    String copy[] = Arrays.copyOf(args, 4);\r\n    System.out.printf(\"Before (copy)\\t\\t%s%n\", Arrays.toString(copy));\r\n    copy[0] = \"A\";\r\n    copy[1] = \"B\";\r\n    copy[2] = \"C\";\r\n    copy[3] = \"D\";\r\n    System.out.printf(\"After (original)\\t%s%n\", Arrays.toInt(args));\r\n    System.out.printf(\"After (copy)\\t\\t%s%n\", (Object)Arrays.toObject(copy));\r\n  }\r\n}",
                    "Language__c":"Java"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uIyIAI"
                    },
                    "Id":"a0xZ00000004uIyIAI",
                    "Question__c":"for(int i=0; i <= 3 ; i++)\r\n{\r\n        switch(i)\r\n        {\r\n                case 0:\r\n                        System.out.println(\"i is 0\");\r\n                        break;\r\n               \r\n                case 1:\r\n                        System.out.println(\"i is 1\");\r\n                        break;\r\n               \r\n                case 2:\r\n                        System.out.println(\"i is 2\");\r\n                        break;\r\n               \r\n                final:\r\n                        System.out.println(\"i is grater than 2\");\r\n                       \r\n        }\r\n}",
                    "Language__c":"Java"
                },
                {
                    "attributes":{
                        "type":"Code_Challenge_Question__c",
                        "url":"/services/data/v24.0/sobjects/Code_Challenge_Question__c/a0xZ00000004uJ3IAI"
                    },
                    "Id":"a0xZ00000004uJ3IAI",
                    "Question__c":"public class FetchCookie {\r\n  public static void main(String args[]) throws Exception {\r\n    String urlString = \"http://java.sun.com\";\r\n    CookieManager manager = new CookieManager();\r\n    CookieHandler.setDefault(manager);\r\n    URL url = new URL(urlString);\r\n    URLConnection connection = url.getConnection();\r\n    Object obj = connection.getContent();\r\n    url = new URL(urlString);\r\n    connection = url.openConnection();\r\n    obj = connection.getContent();\r\n    List<HttpCookie> cookies = cookieJar.getCookies();\r\n    for (HttpCookie cookie : cookies) {\r\n      System.out.println(cookie);\r\n    }\r\n  }\r\n}",
                    "Language__c":"Java"
                }
            ]
        }
    }
}
