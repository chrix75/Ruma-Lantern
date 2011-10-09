package rumal


import static org.junit.Assert.*
import org.junit.*
import org.rumal.bo.Compagny
import org.rumal.svc.ApplicationComponentsService
import org.rumal.bo.Component
import org.rumal.bo.Application
import org.rumal.bo.Employee
import org.rumal.bo.User
import org.rumal.bo.Permission

class ApplicationComponentsServiceIntegrationTests {

    def applicationComponentsService
    Compagny cie
    Application rumalApp
    Component counter
    Component extractor

    @Before
    void setUp() {
        cie = new Compagny(name: 'Ladybird Corp.')
        assert cie.save()

        rumalApp = applicationComponentsService.addApplication(cie, [name: 'Rumal', description: 'A Rumal application for test'])
        counter = applicationComponentsService.addComponent(rumalApp, 'Counter', 'Count records from DB')
        extractor = applicationComponentsService.addComponent(rumalApp, 'Extractor', 'Extract records from DB', [[name: 'extract92', description: 'Extract from 92'], [name: 'extract75', description: 'Extract from Paris']])
    }

    @After
    void tearDown() {
        // Tear down logic here
    }

    @Test
    void testBuildApplication() {
        assert cie.applications.size() == 1
        assert rumalApp

        assert counter
        assert rumalApp.components.size() == 2

        Component fromDb = Component.findByName('Extractor')
        assert fromDb?.permissions.size() == 2
    }

    @Test
    void testUserManagement() {

        Employee darkVader = new Employee(firstName: 'Dark', lastName: 'Vader', email: 'darkvader@blackstar.org')
        cie.addToEmployees(darkVader)

        assert cie.employees.size() == 1

        User dark = new User(login: 'dark', password: 'dark1234')
        User vader = new User(login: 'vader', password: 'dark1234')
        darkVader.addToUsers(dark)
        darkVader.addToUsers(vader)

        darkVader.users.size() == 2
    }

    @Test
    void testRightsManagement() {

        assert extractor.permissions.size() == 2

        // - prepares component's users
        Employee darkVader = new Employee(firstName: 'Dark', lastName: 'Vader', email: 'darkvader@blackstar.org')
        cie.addToEmployees(darkVader)

        assert cie.employees.size() == 1

        User dark = new User(login: 'dark', password: 'dark1234')
        User vader = new User(login: 'vader', password: 'dark1234')
        darkVader.addToUsers(dark)
        darkVader.addToUsers(vader)

        darkVader.users.size() == 2

        // - manages rights
        def extract75 = Permission.findByName('extract75')
        def privilege = dark.addRight(extract75)
        assert privilege
        assert privilege.permission == extract75
        assert dark.privileges.size() == 1
        assert dark.addRight(extract75).permission == extract75
        assert dark.privileges.size() == 1

        dark.removeRight(extract75)
        assert dark.privileges.size() == 0
    }
}
