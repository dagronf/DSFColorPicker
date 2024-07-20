//
//  Copyright © 2024 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import Dispatch

/// A simple locking mechanism using a semaphore
final class SemLock {
	
	/// Locking errors
	enum LockError: Error {
		/// The lock attempt timed out
		case timeout
	}
	
	/// Perform a block within the confines of the lock
	///
	/// Note this function is NOT re-entrant, and will block indefinitely if recursively called
	@discardableResult @inlinable func whileLocked<ReturnType>(_ block: () throws -> ReturnType) rethrows -> ReturnType {
		self.blockingSemaphore__.wait()
		defer { self.blockingSemaphore__.signal() }
		return try block()
	}

	/// Perform a block within the confines of the lock ONLY IF we can get the lock.
	/// If we can't acquire the lock the block is not called
	///
	/// Note this function is NOT re-entrant
	@inlinable func ifLockable(_ block: () -> Void) {
		if self.blockingSemaphore__.wait(timeout: .now()) == .timedOut { return }
		defer { blockingSemaphore__.signal() }
		block()
	}
	
	/// Perform a block within the confines of the lock
	/// - Parameters:
	///   - timeout: The time at which to give up. Defaults to timing out straight away if the lock can't be gotten
	///   - block: The block to perform if the lock is attained
	/// - Returns:
	@discardableResult func tryLock<ReturnType>(
		timeout: DispatchTime = .now(),
		_ block: () throws -> ReturnType
	) rethrows -> Result<ReturnType, Error> {
		if self.blockingSemaphore__.wait(timeout: timeout) == .timedOut {
			return .failure(LockError.timeout)
		}
		defer {
			blockingSemaphore__.signal()
		}
		
		do {
			return .success(try block())
		}
		catch {
			return .failure(error)
		}
	}
	
	// private
	
	private let blockingSemaphore__ = DispatchSemaphore(value: 1)
}
