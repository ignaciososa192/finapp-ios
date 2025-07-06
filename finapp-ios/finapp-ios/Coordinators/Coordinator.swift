import SwiftUI

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func finish() {
        // Default implementation does nothing
    }
}

// MARK: - App Coordinator

final class AppCoordinator: Coordinator, ObservableObject {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    @Published var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        // Check authentication state
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func start() {
        if isLoggedIn {
            showMainTabBar()
        } else {
            showOnboarding()
        }
    }
    
    func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showMainTabBar() {
        let tabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        isLoggedIn = false
        
        // Remove all child coordinators
        childCoordinators.removeAll()
        
        // Show onboarding
        showOnboarding()
    }
}

// MARK: - Onboarding Coordinator

protocol OnboardingCoordinatorDelegate: AnyObject {
    func didFinishOnboarding()
}

final class OnboardingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: OnboardingCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingView = OnboardingView()
        let hostingController = UIHostingController(rootView: onboardingView)
        navigationController.setViewControllers([hostingController], animated: true)
    }
    
    func finish() {
        delegate?.didFinishOnboarding()
    }
}

// MARK: - Main Tab Bar Coordinator

final class MainTabBarCoordinator: Coordinator, MainTabBarCoordinatorDelegate {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var tabBarController: UITabBarController
    private var homeCoordinator: HomeCoordinator
    private var statisticsCoordinator: StatisticsCoordinator
    private var payCoordinator: PayCoordinator
    private var cardsCoordinator: CardsCoordinator
    private var profileCoordinator: ProfileCoordinator
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        
        // Initialize child coordinators
        self.homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        self.statisticsCoordinator = StatisticsCoordinator(navigationController: UINavigationController())
        self.payCoordinator = PayCoordinator(navigationController: UINavigationController())
        self.cardsCoordinator = CardsCoordinator(navigationController: UINavigationController())
        self.profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        
        // Setup tab bar appearance
        setupTabBarAppearance()
    }
    
    func start() {
        // Start child coordinators
        homeCoordinator.start()
        statisticsCoordinator.start()
        payCoordinator.start()
        cardsCoordinator.start()
        profileCoordinator.start()
        
        // Configure tab bar items
        homeCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        
        statisticsCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Statistics",
            image: UIImage(systemName: "chart.pie.fill"),
            tag: 1
        )
        
        payCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Pay",
            image: UIImage(systemName: "dollarsign.circle.fill"),
            tag: 2
        )
        
        cardsCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Cards",
            image: UIImage(systemName: "creditcard.fill"),
            tag: 3
        )
        
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill"),
            tag: 4
        )
        
        // Set view controllers
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            statisticsCoordinator.navigationController,
            payCoordinator.navigationController,
            cardsCoordinator.navigationController,
            profileCoordinator.navigationController
        ]
        
        // Set initial selected index
        tabBarController.selectedIndex = 0
        
        // Present tab bar controller
        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.background)
        
        // Selected item color
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primaryButton)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.primaryButton)]
        
        // Unselected item color
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        // Apply the appearance
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - Home Coordinator

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeView = DashboardView()
        let hostingController = UIHostingController(rootView: homeView)
        navigationController.setViewControllers([hostingController], animated: false)
    }
}

// MARK: - Statistics Coordinator

final class StatisticsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let statisticsView = Text("Statistics View")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        
        let hostingController = UIHostingController(rootView: statisticsView)
        navigationController.setViewControllers([hostingController], animated: false)
    }
}

// MARK: - Pay Coordinator

final class PayCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let payView = Text("Pay View")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        
        let hostingController = UIHostingController(rootView: payView)
        navigationController.setViewControllers([hostingController], animated: false)
    }
}

// MARK: - Cards Coordinator

final class CardsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let cardsView = CardsView()
        let hostingController = UIHostingController(rootView: cardsView)
        navigationController.setViewControllers([hostingController], animated: false)
    }
}

// MARK: - Profile Coordinator

protocol ProfileCoordinatorDelegate: AnyObject {
    func didLogout()
}

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: ProfileCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileView = ProfileView()
            .environmentObject(self)
        let hostingController = UIHostingController(rootView: profileView)
        navigationController.setViewControllers([hostingController], animated: false)
    }
    
    func logout() {
        delegate?.didLogout()
    }
}

// MARK: - Coordinator Environment Key

struct CoordinatorKey: EnvironmentKey {
    static var defaultValue: Coordinator?
}

extension EnvironmentValues {
    var coordinator: Coordinator? {
        get { self[CoordinatorKey.self] }
        set { self[CoordinatorKey.self] = newValue }
    }
}
