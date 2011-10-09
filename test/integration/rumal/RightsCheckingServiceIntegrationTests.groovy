package rumal

import static org.junit.Assert.*
import org.junit.*
import org.rumal.bo.User
import org.rumal.bo.Employee
import org.rumal.bo.Permission
import org.rumal.bo.Component
import org.rumal.bo.Application
import org.rumal.bo.Compagny
import org.rumal.results.ResultChecking

class RightsCheckingServiceIntegrationTests {

    def rightsCheckingService
    def applicationComponentsService

    @Before
    void setUp() {
        // - defines a complete components tree
        Compagny cie = new Compagny(name: 'Ladybird Corp.')
        assert cie.save()

        Application rumalApp = applicationComponentsService.addApplication(cie, [name: 'My App', description: 'A Rumal application for test'])
        assert cie.applications.size() == 1

        Component extractor = applicationComponentsService.addComponent(rumalApp, 'Extractor', 'Extract records from DB')
        assert rumalApp.components.size() == 1

        Permission extract92 = new Permission(name: 'extract', description: 'Extract from 92')
        Permission extract75 = new Permission(name: 'extract75', description: 'Extract from 75')

        extractor.addToPermissions(extract75)
        extractor.addToPermissions(extract92)
        assert extractor.permissions.size() == 2

        // - prepares component's users
        Employee darkVader = new Employee(firstName: 'Dark', lastName: 'Vader', email: 'darkvader@blackstar.org')
        cie.addToEmployees(darkVader)

        assert cie.employees.size() == 1

        User dark = new User(login: 'dark', password: 'dark1234')
        darkVader.addToUsers(dark)

        darkVader.users.size() == 1
    }

    @After
    void tearDown() {
        // Tear down logic here
    }

    @Test
    void testUnauthorizedUser() {
        User dark = User.findByLogin('dark')
        assert rightsCheckingService.checkRight(dark.id, 'My App', 'Extractor', 'extract') == ResultChecking.CHECKING_UNAUTHORIZED_USER
    }

    @Test
    void testAuthorizedUser() {
        User dark = User.findByLogin('dark')
        Permission extract = Permission.findByName('extract')
        assert dark.addRight(extract)
        assert rightsCheckingService.checkRight(dark.id, 'My App', 'Extractor', 'extract') == ResultChecking.CHECKING_AUTHORIZED_USER
    }

    @Test
    void testUnknownUser() {
        assert rightsCheckingService.checkRight(500, 'My App', 'Extractor', 'extract') == ResultChecking.CHECKING_UNKNOWN_USER
    }


    @Test
    void testUnknownAction() {
        User dark = User.findByLogin('dark')
        assert rightsCheckingService.checkRight(dark.id, 'My App', 'Extractor', 'not exist') == ResultChecking.CHECKING_UNKNOWN_ACTION
    }

}
