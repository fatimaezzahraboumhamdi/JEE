package ma.bankati.config;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.annotation.WebServlet;
import java.util.Enumeration;
import java.util.Properties;
import ma.bankati.dao.dataDao.IDao;
import ma.bankati.dao.userDao.IUserDao;
import ma.bankati.service.authentification.IAuthentificationService;
import ma.bankati.service.moneyServices.IMoneyService;

@WebListener
public class WebContext implements ServletContextListener {


    static void loadApplicationContext(ServletContext application){
        var configFile = Thread.currentThread().getContextClassLoader().getResourceAsStream("configFiles/beans.properties");

        if (configFile != null) {
            Properties properties = new Properties();
            try {
                properties.load(configFile);
                String dataDaoClassName = properties.getProperty("dataDao");
                String moneyServClassName = properties.getProperty("moneyService");
                String userDaoClassName = properties.getProperty("userDao");
                String authServClassName = properties.getProperty("authService");

                Class<?> cDataDao = Class.forName(dataDaoClassName);
                IDao dataDao = (IDao) cDataDao.getDeclaredConstructor().newInstance();

                Class<?> cMoneyService = Class.forName(moneyServClassName);
                IMoneyService moneyService = (IMoneyService) cMoneyService.getDeclaredConstructor(IDao.class).newInstance(dataDao);


                Class<?> cUserDao = Class.forName(userDaoClassName);
                IUserDao userDao = (IUserDao) cUserDao.getDeclaredConstructor().newInstance();

                Class<?> cAuthService = Class.forName(authServClassName);
                IAuthentificationService authService = (IAuthentificationService) cAuthService.getDeclaredConstructor(IUserDao.class).newInstance(userDao);


                // Enregistrement des beans aussi avec des noms explicites
               application.setAttribute("dataDao", dataDao);
               application.setAttribute("moneyService", moneyService);
               application.setAttribute("userDao", userDao);
               application.setAttribute("authService", authService);


            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            System.err.println("Erreur : Le fichier beans.properties est introuvable !");
        }
    }



    @Override
    public void contextInitialized(ServletContextEvent ev) {

        var application = ev.getServletContext();
        application.setAttribute("AppName", "Bankati");
        loadApplicationContext(application);

        System.out.println("Application Started and context initialized");
    }

    @Override
    public void contextDestroyed(ServletContextEvent ev) {

        var application = ev.getServletContext();

        Enumeration<String> attributeNames = application.getAttributeNames();

        while (attributeNames.hasMoreElements()) {
            String name = attributeNames.nextElement();
            application.removeAttribute(name);
        }

        System.out.println("Application Stopped");
    }
}
