/**
 * app.js — AngularJS Application
 * ============================================================
 * SYLLABUS TOPIC: Web Application Frameworks — AngularJS 1.x
 *
 * Key AngularJS Concepts demonstrated:
 *
 * 1. MODULE (angular.module)
 *    - The container that holds all parts of the app
 *    - Defined ONCE with [] (dependency list)
 *    - Retrieved (not redefined) elsewhere with just the name
 *
 * 2. CONTROLLER ($scope injection)
 *    - Function that provides data and behavior to the View
 *    - $scope = the "ViewModel" object bridging controller & view
 *    - All properties/functions attached to $scope are accessible
 *      in the corresponding HTML view via {{ }} binding
 *
 * 3. TWO-WAY DATA BINDING (ng-model)
 *    - View field change → $scope variable updates (user types)
 *    - $scope variable change → View updates (calculateNights)
 *    - Achieved without manual DOM manipulation
 *
 * 4. FORM VALIDATION
 *    - AngularJS tracks state via the form object: $valid, $dirty, $error
 *    - ng-show/ng-hide toggle error messages based on field state
 *
 * 5. $http service (optional, shown in submitBooking)
 *    - AngularJS built-in for AJAX HTTP calls
 *    - Here we demonstrate it but fall back to native form submit
 *    - for compatibility with Servlet session-based page flow
 * ============================================================
 */

// ── 1. Define the AngularJS Module ──────────────────────────────────────────
// angular.module('name', [dependencies]) — the [] means no dependencies
var hotelApp = angular.module('hotelApp', []);

// ════════════════════════════════════════════════════════════════════════════
// CONTROLLER 1: FilterController
// Used on index.jsp to manage room type filter state
// ════════════════════════════════════════════════════════════════════════════
hotelApp.controller('FilterController', ['$scope', '$window', function($scope, $window) {

    // $scope.selectedType is bound to the active filter button
    $scope.selectedType = 'All';

    /**
     * filterRooms(type)
     * Called via ng-click on filter buttons.
     * Updates the URL with the type parameter, triggering a full
     * page request to RoomSearchServlet (server-side filtering).
     *
     * In a pure SPA, this would call $http.get() and update $scope.rooms.
     * Here we use the traditional JSP model with server-side rendering.
     *
     * @param {string} type - Room type to filter by
     */
    $scope.filterRooms = function(type) {
        $scope.selectedType = type;
        // Redirect to servlet with filter param
        if (type === 'All') {
            $window.location.href = '/rooms';
        } else {
            $window.location.href = '/rooms?type=' + encodeURIComponent(type);
        }
    };

}]);


// ════════════════════════════════════════════════════════════════════════════
// CONTROLLER 2: BookingController
// Used on book.jsp — manages the entire booking form
// ════════════════════════════════════════════════════════════════════════════
hotelApp.controller('BookingController', ['$scope', '$http', function($scope, $http) {

    // ── Initialize scope model ───────────────────────────────────────────────
    // $scope.booking is two-way bound to all form fields via ng-model="booking.xxx"
    $scope.booking = {
        guestName:       '',
        guestEmail:      '',
        guestPhone:      '',
        checkInDate:     '',
        checkOutDate:    '',
        specialRequests: ''
    };

    // Derived values (calculated, not directly bound)
    $scope.totalNights = 0;
    $scope.totalPrice  = 0;
    $scope.dateError   = '';
    $scope.submitting  = false;
    $scope.showDebug   = false; // Toggle via console: angular.element(document.body).scope().showDebug = true

    // Price per night — injected from JSP via window.ROOM_PRICE_PER_NIGHT
    var pricePerNight = window.ROOM_PRICE_PER_NIGHT || 0;

    // ── FUNCTION: calculateNights() ─────────────────────────────────────────
    /**
     * Called via ng-change on both date inputs.
     * Demonstrates AngularJS two-way data binding:
     *   - Reads $scope.booking.checkInDate & checkOutDate (bound to form fields)
     *   - Writes to $scope.totalNights & $scope.totalPrice
     *   - The view automatically reflects the new values via {{ }} binding
     */
    $scope.calculateNights = function() {
        $scope.dateError  = '';
        $scope.totalNights = 0;
        $scope.totalPrice  = 0;

        var checkIn  = $scope.booking.checkInDate;
        var checkOut = $scope.booking.checkOutDate;

        if (!checkIn || !checkOut) return;

        var inDate  = new Date(checkIn);
        var outDate = new Date(checkOut);
        var today   = new Date();
        today.setHours(0, 0, 0, 0);

        // Validation: Check-in must be today or later
        if (inDate < today) {
            $scope.dateError = 'Check-in date cannot be in the past.';
            return;
        }

        // Validation: Check-out must be after check-in
        if (outDate <= inDate) {
            $scope.dateError = 'Check-out date must be after check-in date.';
            return;
        }

        // Calculate nights: difference in milliseconds → days
        var msPerDay   = 1000 * 60 * 60 * 24;
        var nights     = Math.round((outDate - inDate) / msPerDay);

        $scope.totalNights = nights;
        $scope.totalPrice  = nights * pricePerNight;
    };

    // ── FUNCTION: formatPrice() ─────────────────────────────────────────────
    /**
     * Formats a number as Indian Rupee currency string.
     * Used in {{formatPrice(totalPrice)}} in the template.
     *
     * @param {number} amount
     * @returns {string} formatted price
     */
    $scope.formatPrice = function(amount) {
        if (!amount) return '₹0';
        return '₹' + Number(amount).toLocaleString('en-IN', {
            maximumFractionDigits: 0
        });
    };

    // ── FUNCTION: submitBooking() ───────────────────────────────────────────
    /**
     * Called via ng-submit on the booking form.
     *
     * Performs client-side validation before allowing form to submit.
     * Since we're in a traditional JSP/Servlet flow (not a full SPA),
     * we let the native form submit (action="/book" method="POST") proceed
     * after AngularJS validation passes.
     *
     * In a pure AngularJS SPA, you would:
     *   $http.post('/book', $scope.booking).then(function(res) { ... });
     *
     * @param {Object} form  - AngularJS form controller object ($valid, $dirty, etc.)
     * @param {Event}  $event - DOM submit event
     */
    $scope.submitBooking = function(form, $event) {
        // Mark all fields as dirty to trigger validation display
        form.$setDirty();
        angular.forEach(form, function(value, key) {
            if (key[0] !== '$') {
                if (value && value.$setDirty) {
                    value.$setDirty();
                }
            }
        });

        // Stop if AngularJS form is invalid
        if (form.$invalid) {
            $event.preventDefault();
            return;
        }

        // Stop if date validation failed
        if ($scope.totalNights <= 0 || $scope.dateError) {
            $event.preventDefault();
            return;
        }

        // All good — allow native form submit to BookingServlet POST
        $scope.submitting = true;
        // Native form submit proceeds (no $event.preventDefault())
    };

}]);


// ════════════════════════════════════════════════════════════════════════════
// CUSTOM DIRECTIVE: hotel-card-animate
// Demonstrates AngularJS Directives (extending HTML)
// ════════════════════════════════════════════════════════════════════════════
hotelApp.directive('hotelCardAnimate', function() {
    return {
        restrict: 'A', // Used as attribute: <div hotel-card-animate>
        link: function(scope, element) {
            // Add CSS class after a short delay for a stagger effect
            var index = parseInt(element.attr('data-index') || 0);
            setTimeout(function() {
                element.addClass('card-visible');
            }, index * 100);
        }
    };
});
